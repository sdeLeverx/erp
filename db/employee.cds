namespace uz.erp;

using {uz.erp as erp} from './index';
using {cuid, managed} from '@sap/cds/common';

entity Employee: cuid, managed {
  device  : Association to many erp.Device
                         on device.employee = $self;
  name  : String(100) @mandatory;
  email  : String(100) @mandatory;
  gender : String(10);
}