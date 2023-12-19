pageextension 50102 PurchaseOrderList extends "Purchase Order List"
{
    actions
    {
        modify(Print)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Released);
            end;
        }
        modify(AttachAsPDF)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Released);
            end;
        }
    }
}
