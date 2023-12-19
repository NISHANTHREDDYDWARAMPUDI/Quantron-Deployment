pageextension 50062 ItemLedgerEntries extends "Item Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Revision field.';
            }

            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Comment field.';
            }
        }
    }
}
