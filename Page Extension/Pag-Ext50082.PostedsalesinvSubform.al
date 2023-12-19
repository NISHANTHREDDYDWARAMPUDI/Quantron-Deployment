pageextension 50082 PostedSalesInvSubform extends "Posted Sales Invoice Subform"
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