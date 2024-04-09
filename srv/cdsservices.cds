using {nick.db.cdsViews} from '../db/cdsViews';

service CDSservice @(path:'/CDSservice'){
    entity POWorklist as projection on cdsViews.POWorklist;

}