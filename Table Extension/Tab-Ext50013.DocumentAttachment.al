tableextension 50013 DocumentAttachment extends "Document Attachment"
{
    fields
    {
        field(50001; "Include in Mail(Purch.)"; Boolean)
        {
            Caption = 'Include in Mail(Purch.)';
            DataClassification = ToBeClassified;
        }
        field(50002; "Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = ToBeClassified;
        }
    }
}
