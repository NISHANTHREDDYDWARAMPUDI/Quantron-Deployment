tableextension 50051 EntrySummary extends "Entry Summary"
{
    fields
    {
        field(50000; Revision; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revision';
        }
    }

    var
        myInt: Integer;
}