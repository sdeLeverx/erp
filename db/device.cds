namespace uz.erp;

using {uz.erp as erp} from './index';
using {Currency, cuid, managed} from '@sap/cds/common';

entity Device: cuid, managed {
  employee : Association to erp.Employee;
  title   : String(100) @mandatory;
  price  : Decimal(9,2);
  currency : Currency;
  // virtual currencyInSum : String(11) @Core.Computed: false;
}