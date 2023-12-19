pageextension 50088 PostedPurchInvSubform extends "Posted Purch. Invoice Subform"
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