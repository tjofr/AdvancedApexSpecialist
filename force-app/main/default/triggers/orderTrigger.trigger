/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (after update)
{
    OrderHelper(TGrigger.new,Trigger.old);
}