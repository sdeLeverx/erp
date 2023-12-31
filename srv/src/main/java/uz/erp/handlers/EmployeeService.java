package uz.erp.handlers;

import cds.gen.employeeservice.Device_;
import cds.gen.employeeservice.Employee_;
import cds.gen.employeeservice.Device;
import cds.gen.employeeservice.Employee;
import cds.gen.employeeservice.EmployeeService_;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import uz.erp.events.EmployeeEventContext;
import cds.gen.employeeservice.GetAllDevicesOfEmployeeContext;;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Component
//@ServiceName("EmployeeService")
@ServiceName(EmployeeService_.CDS_NAME)
@RequiredArgsConstructor
public class EmployeeService implements EventHandler {
    private final PersistenceService persistenceService;

    @Before(event = {CqnService.EVENT_CREATE, CqnService.EVENT_UPDATE}, entity = Device_.CDS_NAME)
    public void validateEmployeeId(List<Device> devices) {
        for (Device device : devices) {
            String employeeId = device.getEmployeeId();

            // check if the employee id exists before assigning device
            if (employeeId != null) {
                CqnSelect sel = Select.from(Employee_.class).where(b -> b.ID().eq(employeeId));
                Employee employee = persistenceService.run(sel).first(Employee.class)
                        .orElseThrow(() -> new ServiceException(ErrorStatuses.NOT_FOUND, "Employee does not exist"));

                log.info("Employee found " + employee.getId() + " -> " + employee.getName());
            }

        }
    }

    @On(event = GetAllDevicesOfEmployeeContext.CDS_NAME, entity = Employee_.CDS_NAME)
    public void getAllDevicesOfEmployee(EmployeeEventContext context) {
        CqnSelect select = context.getCqn();
        Integer rate = context.getRate();
        String  employeeId = context.getEmployeeId();

        // check if the employee id exists before assigning device
        Employee employee = persistenceService.run(select).first(Employee.class)
                .orElseThrow(() -> new ServiceException(ErrorStatuses.NOT_FOUND, "Employee does not exist"));

        // get all devices of employee if exists
        CqnSelect sel = Select.from(Device_.class).where(b -> b.employee_ID().eq(employee.getId()));
        List<Device> devices = persistenceService.run(sel).listOf(Device.class);

        // calculate amount in local currency
        if (devices != null && rate != null) {
            for (Device device : devices) {
                log.info("Device title " + device.getTitle());
                device.setAmountInLocalCurrency(device.getPrice().multiply(BigDecimal.valueOf(rate)));
            }
        }

        context.setResult(devices);
    }
}
