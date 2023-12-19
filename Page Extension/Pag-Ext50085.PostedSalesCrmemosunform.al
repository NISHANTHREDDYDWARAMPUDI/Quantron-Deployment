pageextension 50085 PostedSalesCrmemoSubform extends "Posted Sales Cr. Memo Subform"
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