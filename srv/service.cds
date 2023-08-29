using {uz.erp as erp} from '../db/employee';

service EmployeeService {
  /**
  * entity DeviceList as SELECT from Device {
  *   ID, title, price, currency,
  *   employee.id as employee
   }; */

  entity Employee as projection on erp.Employee
    actions {
        action getAllDevicesOfEmployee (id: String) returns Device;
        function getEmployeesCount() returns Integer;
      };

   @(restrict: [
          { grant: '*', to: 'Administrators' },
          { grant: '*', where: 'createdBy = $user' }
      ])
  entity Device as projection on erp.Device;
}
