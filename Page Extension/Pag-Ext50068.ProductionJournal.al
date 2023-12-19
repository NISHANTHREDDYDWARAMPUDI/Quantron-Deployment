pageextension 50068 ProductionJournal extends "Production Journal"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the journal line.';
            }
        }
        addafter(Description)
        {
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Revision field.';
            }
        }
    }
}
