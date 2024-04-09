namespace nick.db;

using {nick.db.transaction } from './datamodel';

context cdsViews {
    define view ![POWorklist] as 
    select from transaction.purchaseorder{

        key PO_id as ![PurchaseOrderId],
        PARTNER_GUID.BP_ID as ![PartnerId],
        PARTNER_GUID.COMPANY_NAME as ![CompanyName],
        GROSS_AMOUNT as ![POGrossAmount],
        CURRENCY_CODE as ![POCurrencyCode],
        LIFECYCLE_STATUS as ![PoStatus],
        key Items.PO_ITEM_POS as ![ItemPosition],
        Items.PRODUCT_GUID.PRODUCT_ID as ![ProductId],
        Items.PRODUCT_GUID.DESCRIPTION as ![ProductName],
        PARTNER_GUID.ADDRESS_GUID.CITY as ![City],
        PARTNER_GUID.ADDRESS_GUID.Country as ![Country],
        Items.NET_AMOUNT as ![NetAmount], 
        Items.TAX_AMOUNT as ![TaxAmmount], 
        Items.CURRENCY_CODE as ![CurrencyCode]
               
    }
}



