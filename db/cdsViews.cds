namespace nick.db;

using {
    nick.db.transaction,
    nick.db.master
} from './datamodel';

context cdsViews {
    define view ![POWorklist] as
        select from transaction.purchaseorder {

            key PO_id                             as ![PurchaseOrderId],
                PARTNER_GUID.BP_ID                as ![PartnerId],
                PARTNER_GUID.COMPANY_NAME         as ![CompanyName],
                GROSS_AMOUNT                      as ![POGrossAmount],
                CURRENCY_CODE                     as ![POCurrencyCode],
                LIFECYCLE_STATUS                  as ![PoStatus],
            key Items.PO_ITEM_POS                 as ![ItemPosition],
                Items.PRODUCT_GUID.PRODUCT_ID     as ![ProductId],
                Items.PRODUCT_GUID.DESCRIPTION    as ![ProductName],
                PARTNER_GUID.ADDRESS_GUID.CITY    as ![City],
                PARTNER_GUID.ADDRESS_GUID.Country as ![Country],
                Items.NET_AMOUNT                  as ![NetAmount],
                Items.TAX_AMOUNT                  as ![TaxAmmount],
                Items.CURRENCY_CODE               as ![CurrencyCode]

        };

    //creating view using select query instead of using as projection on
    define view productValueHelp as
        select from master.product {
            @EndUserText.label: [{
                language: 'EN',
                text    : 'Product ID'
            }, {
                language: 'DE',
                text    : 'Prodekt ID'
            }]
            PRODUCT_ID  as ![ProductId],
            @EndUserText.label: [{
                language: 'EN',
                text    : 'Product Description'
            }, {
                language: 'DE',
                text    : 'Prodekt descrupton'
            }]
            DESCRIPTION as ![Description]


        };

    define view ![ItemView] as
        select from transaction.poitems { //view which exposing items data
            PARENT_KEY.PARTNER_GUID.NODE_KEY as ![Partner],
            PRODUCT_GUID.NODE_KEY            as ![ProductId],
            CURRENCY_CODE                    as ![CurrencyCode],
            GROSS_AMOUNT                     as ![GrossAmount],
            NET_AMOUNT                       as ![NetAmount],
            TAX_AMOUNT                       as ![TaxAmount],
            PARENT_KEY.OVERALL_STATUS        as ![POStatus]

        };

    //fetching all data from productTable and doing sum of total gross amount
    //this query will be perform on database//it will retrive data much faster
        //different different view selection technique-this is direct select query
    define view ProductViewSub as
    select from master.product as prod { //original anubhav one
            PRODUCT_ID        as ![ProductId],
            texts.DESCRIPTION as ![Description],

            (
                select from transaction.poitems as a {
                    SUM(a.GROSS_AMOUNT) as SUM
                } where a.PRODUCT_GUID.NODE_KEY = prod.NODE_KEY
                ) as  PO_SUM : Decimal(10,2) //todo
        };
    
        
    //creating view little different way//expose association view -view which will have selection of primary records and then dependent record it will expose as a association
    //that association can be use in another view
    //view on view technique of view creation
    define view ProductView as select from master.product
    mixin { //mixing other view with association
        PO_ORDERS: Association[*] to ItemView on 
        PO_ORDERS.ProductId = $projection.ProductId
    }
    into {
    NODE_KEY as ![ProductId],
    DESCRIPTION,
    //CATEGORY as ![Category],
    PRICE as ![Price],
    TYPE_CODE  as ![TypeCode],
    SUPPLIER_GUID.BP_ID as ![BPId],
    SUPPLIER_GUID.COMPANY_NAME as ![CompanyName],
    SUPPLIER_GUID.ADDRESS_GUID.CITY as ![City],
    SUPPLIER_GUID.ADDRESS_GUID.Country as![Country],
    //Exposed Association ehich means when someone read the view
    //data for orders wont be read
    //until unless someone consume the association
    PO_ORDERS 
    };
    define view CProductValuesView as 
    select from ProductView {
        ProductId,
        Country,
        PO_ORDERS.CurrencyCode,
        sum(PO_ORDERS.GrossAmount) as  ![POGrossAmount]: Decimal(10,2) //todo additionally added decimal type
    }
    group by ProductId,Country,PO_ORDERS.CurrencyCode

}
