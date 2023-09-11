package uz.erp.events;

import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.EventContext;
import com.sap.cds.services.EventName;
import cds.gen.employeeservice.Device;
import cds.gen.employeeservice.GetAllDevicesOfEmployeeContext;

import java.util.List;


//@EventName("getAllDevicesOfEmployee")
@EventName(GetAllDevicesOfEmployeeContext.CDS_NAME)
public interface EmployeeEventContext extends EventContext {

    // CqnSelect that points to the entity the action was called on
    CqnSelect getCqn();
    void setCqn(CqnSelect select);

    // The 'rate' input parameter
    Integer getRate();
    void setRate(Integer id);

    // The 'employeeId' input parameter
    String getEmployeeId();
    void setEmployeeId(String employeeId);

    // The return value
    void setResult(List<Device> devices);
    List<Device> getResult();
}
