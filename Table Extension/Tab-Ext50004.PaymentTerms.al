tableextension 50004 PaymentTermsExt extends "Payment Terms"
{
    fields
    {
        field(50000; "Invoice Type"; Option)
        {
            Caption = 'Invoice Type';
            OptionMembers = " ","Pre Payment","Down Payment";
            OptionCaption = ' ,Pre Payment,Down Payment';
            DataClassification = ToBeClassified;
        }
        //B2BDNROn10May2023>>
        field(50001; "English Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'English Description';
        }
        //B2BDNROn10May2023<<
    }
}
