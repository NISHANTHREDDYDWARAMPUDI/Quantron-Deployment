tableextension 50037 "Sales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(50000; "Total Gross Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Gross Weight';
        }
        field(50001; "Total Measurements"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Total Measurements';
        }
    }
}