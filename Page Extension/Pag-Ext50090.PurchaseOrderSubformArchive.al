pageextension 50090 PurchaseOrderSubformArchive extends "Purchase Order Archive Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
            }
        }
    }

}