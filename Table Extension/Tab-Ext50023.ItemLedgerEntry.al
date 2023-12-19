tableextension 50023 ItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        field(50000; Comment; Code[20])
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50001; "Comment Description"; Code[50])
        {
            Caption = 'Comment Description';
            DataClassification = ToBeClassified;
        }
        field(50002; Revision; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revision';
        }
    }
}
