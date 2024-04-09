namespace nick.common;

using {sap, Currency, temporal, managed  } from '@sap/cds/common';

type gender: String(1) enum { //fixed set of domain values, if something not declared here then that value we will not able to access it

 male = 'M';
 female ='F';
 NonBinary= 'N';
 nonDisclosure='D';
 selfDescribe='S';

};
//every currency will have currency code, to convert that we use anotation called Semantics.amount.currencyCode
//type AmountT: Decimal(15,2)@(
    type AmountT: Decimal(0,0)@(
    Semantics.amount.currencyCode: 'CURRENCY_CODE',
    sap.unit: 'CURRENCY_CODE'
);
//grouping below fields in entity/i will directly use "Amount" in other tables
abstract entity Amount  { //if we want this fields in 50 tables then we cannot write it every time so we create abstract entity/ its like table object
    CURRENCY_CODE:String(4);
    GROSS_AMOUNT:AmountT;
    NET_AMOUNT:AmountT;
    TAX_AMOUNT: AmountT;
}

type PhoneNumber: String(30)@assert.format : '/^\+?[\d{1,3}\s?-?\(?]\d{3}[\s.-]\d{4}$/';

type Email: String(50)@assert.format: '^(\+\d{1,2}\s?)?(\d{3}|\(\d{3}\))[\s.-]?\d{3}[\s.-]?\d{4}$';
