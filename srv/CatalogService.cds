using {nick.db.master, nick.db.transaction } from '../db/datamodel';

service CatalogService@(path:'/CatalogService'){ //exposing tables //we can give any name to service by adding @(path:'/Nikhil')
    entity EmployeeSet as projection on master.employees;
    entity AddressSet as projection on master.address;
    entity ProductSet as projection on master.product;
    //entity ProductTexts as projection on master.prodtext; //Commented due to trying to achieve through localization
    entity BPSet as projection on master.businesspartner;
    //entity POSet as projection on transaction.purchaseorder; //todo just added
    //TODO /creating linked association for $expand--not working yet
    entity POs @(title: '{i18n>PoHeader}') as projection on transaction.purchaseorder{*, Items: redirected to POItems}
    entity POItems  @(title: '{i18n>poitems}') as projection on transaction.poitems{*, PARENT_KEY: redirected to POs, PRODUCT_GUID: redirected to ProductSet}

}
