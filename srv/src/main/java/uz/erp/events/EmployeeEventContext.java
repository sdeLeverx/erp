package uz.erp.events;

import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.EventContext;
import com.sap.cds.services.EventName;
import cds.gen.employeeservice.Device;
import cds.gen.employeeservice.GetAllDevicesOfEmployeeContext;


//@EventName("getAllDevicesOfEmployee")
@EventName(GetAllDevicesOfEmployeeContext.CDS_NAME)
public interface EmployeeEventContext extends EventContext {

    // CqnSelect that points to the entity the action was called on
    CqnSelect getCqn();
    void setCqn(CqnSelect select);

    // The 'id' input parameter
    String getID();
    void setID(String id);

    // The return value
    void setResult(Device device);
    Device getResult();
}
