tableextension 50056 ItemCategoryExt extends "Item Category"
{
    fields
    {
        field(50010; "FG No.Series"; Code[20])
        {
            Caption = 'FG No.Series';
            TableRelation = "No. Series".Code;
            DataClassification = ToBeClassified;
        }
        field(50011; FG; Boolean)
        {
            Caption = 'FG';
            DataClassification = ToBeClassified;

        }

    }

    var
        myInt: Integer;


}