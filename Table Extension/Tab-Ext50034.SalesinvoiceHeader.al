tableextension 50034 "Sales Invoice Header" extends "Sales Invoice Header"
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