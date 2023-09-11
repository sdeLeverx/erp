using {uz.erp as erp} from '../db/employee';

service EmployeeService {
  /**
  * entity DeviceList as SELECT from Device {
  *   ID, title, price, currency,
  *   employee.id as employee
   }; */

  entity Employee as projection on erp.Employee
    actions {
        action getAllDevicesOfEmployee (rate: Integer, employeeId: String) returns many Device;
      };

   @(restrict: [
          { grant: '*', to: 'Administrators' },
          { grant: '*', where: 'createdBy = $user' }
      ])
  entity Device as projection on erp.Device;
}
