/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order(after update){
   OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
}