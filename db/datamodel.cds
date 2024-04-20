namespace nick.db;

type Guid : String(32); //user define reusable data types

//importing std aspect/press control and click on this link we will navigate to dependency files/all aspects we can check
using {
    cuid,
    managed,
    temporal,Currency
} from '@sap/cds/common'; //its like we do in abap .INCLUDE
using {nick.common} from './csv/nickcustomaspects'; //custom aspect created for gender

//in abap we were using delivery class means what time of data this table will hold eg transactional. 
//in capm we use context to achieve the same one context can have many entity/tables
context master { 
    entity businesspartner { //tables
        key NODE_KEY      : String(132);
            EMAIL_ADDRESS : String(164);
            PHONE_NO      : String(144);
            FAX_NUMBER    : String(144);
            WEB_ADDRESS   : String(164);
            ADDRESS_GUID  : Association to address; //it will directly go and check pripmary key of address table
            BP_ID         : String(116);
            COMPANY_NAME  : String(184);
    }
    annotate businesspartner { //I wanted to make columns name language specific so  i am anotating businesspartner table with i18n
    NODE_KEY @title: '{i18n>bp_key}';
    BP_ID @title: '{i18n>bp_id}';
    }

    entity address {
        key NODE_KEY        : Guid;
            CITY            : String(64);
            POSTAL_CODE     : Guid;
            BUILDING        : String(64);
            STREET          : String(64);
            Country         : String(2);
            VAL_END_DATE    : Date;
            LATITUDE        : Decimal;
            LONGITUDE       : String(80);
            businesspartner : Association to one businesspartner on businesspartner.ADDRESS_GUID = $self;
    //$self is a keyword which represents primary key of current table(NODE_KEY) it will compare with businesspartner address_guid
    }

    // entity prodtext{ //achieving same in another way by using localized  concept
    //     key NODE_KEY: Guid;
    //     PARENT_KEY: Guid;
    //     LANGUAGE: String(2);
    //     TEXT: String(256);
    // }

    entity product {
        key NODE_KEY: Guid;
        PRODUCT_ID:String(28);
        TYPE_CODE: String(2);
        CAREGORY:String(32);
        //DESC_GUID: Association to  prodtext; //Always remember if we are doing association then change column name of table here DESC_GUID_PRIMARY KEY OF PRODTEXT TABLE(DESC_GUID_NODE_KEY)
        DESCRIPTION: localized String(255); //localized is the keyword if we are using like this then system will create new table called product_Texts
        NAME: localized String(65); 
        //localized-  we will create separate csv file for this columns NODE_KEY, locale, DESCRIPTION/ system will check this file first based on browser language 
        //if no record match according to the language then it will take description from product table(so we have to add one description column in product table as well)
        SUPPLIER_GUID: Association to  master.businesspartner; //TABLE Column name become SUPPLIER_GUID_NODE_KEY
        TAX_TARIF_CODE: Integer;
        MEASURE_UNIT: String(2);
        WEIGHT_MEASURE: Integer;
        WEIGHT_UNIT: String(2);
        CURRENCY_CODE: String(4);
        PRICE:Decimal;
        WIDTH:Decimal;
        HEIGHT: Decimal;
        DIM_UNIT:String(2);
        }

    //two aspects we are using , cuid is unique id and managed is like admin fields(eg createdAt, createdby, modifyat,modifyby)
    //cuid will provide unique ID for each record and managed will provide createdat, createdby, modifyat,by
    entity employees : cuid,managed { //todo i have removed temporal aspect
        nameFirst    : String(40);
        nameMiddle   : String(40);
        nameLast     : String(40);
        nameInitials : String(40);
        sex          : common.gender; //custom aspect created, no need to use whole namespace afterdot we can use eg common.gender
        Language     : String(40);
        phoneNumber  : common.PhoneNumber;
        Email        : common.Email; //custom aspect//we can do formatting also with the help cds annotations and aspects
        LoginName    : String(40);
        Currency: Currency; //standard Aspect/remember to always import at top//TODO
        //Currency_code: String(32);
        SalaryAmount : common.AmountT; //custom aspect
        AccountNumber: String(30);
        BankId:        String(40);
        BankName:       String(50);
    }
}

context transaction {

    entity purchaseorder: common.Amount { //usinng common.Ammount custom aspect/abstract entity

        key NODE_KEY: Guid;
            PO_id: String(24);
            PARTNER_GUID: Association to master.businesspartner;
            LIFECYCLE_STATUS: String(1);
            OVERALL_STATUS: String(1);
            Items: Association to many poitems on Items.PARENT_KEY = $self //TODO//removed the "Items"  column from csv file its working now(i think PARENT_KEY doing that work already)
            //Items: String(20);
            
    }

    entity poitems : common.Amount { //removed currency_code gross_amount and TAX_AMOUNT instead used aspects/custom aspect/abstract entity
        key NODE_KEY     : Guid;
            PARENT_KEY   : Association to purchaseorder;
            PO_ITEM_POS  : Integer;
            PRODUCT_GUID : Association to  master.product; //to do
            // CURRENCY_CODE: String(4);
            //GROSS_AMOUNT:Decimal;
            // TAX_AMOUNT:Decimal;

    }
}
