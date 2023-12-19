tableextension 50047 SalesInvoiceLine extends "Sales Invoice Line"
{
    fields
    {
        field(50002; Revision; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revision';
        }
    }
}