pageextension 50080 PostedSalesShptSubform extends "Posted Sales Shpt. Subform"
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