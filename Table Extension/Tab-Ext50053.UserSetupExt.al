tableextension 50053 UserSetupExt extends "User Setup"
{
    fields
    {
        field(50001; "Item Block"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Access Item Block';

        }
        field(50002; "Vendor Privacy Block"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Access Vendor Privacy Block';
        }
        field(50003; "Access Item Journals"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Access Item Journals';

        }
        field(50004; "Access Item Reclass Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Access Item Reclassification Journals';

        }
    }
}
