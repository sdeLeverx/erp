using {uz.erp as erp} from '../db/employee';

service EmployeeService {
  entity Employee as projection on erp.Employee;

   @(restrict: [
          { grant: '*', to: 'Administrators' },
          { grant: '*', where: 'createdBy = $user' }
      ])
  entity Device as projection on erp.Device;
}
