using {nick.db.cdsViews} from '../db/cdsViews';
using {
    nick.db.master,
    nick.db.transaction
} from '../db/datamodel';

//exposing service
service CDSservice@(path: '/CDSservice') {
    entity POWorklist as projection on cdsViews.POWorklist;
    
    entity ProductOrders as projection on cdsViews.ProductViewSub;
    entity ProductAggregation  as projection on cdsViews.CProductValuesView;//todo
    
}
