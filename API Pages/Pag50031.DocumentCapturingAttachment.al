page 50031 DocumentCapturingAttachment
{
    APIGroup = 'documentcapturingattachment';
    APIPublisher = 'quantron';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'documentCapturingAttachment';
    DelayedInsert = true;
    EntityName = 'attachments';
    EntitySetName = 'attachments';
    PageType = API;
    SourceTable = "Document Attachment";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(documentID; DocumentID)
                {
                    Caption = 'Document ID';
                    trigger OnValidate()
                    var
                        DocumentCapturing: Record "Document Capturing Header";
                    begin
                        if DocumentID = '' then
                            exit;
                        Evaluate(SystemID, DocumentID);
                        if DocumentCapturing.GetBySystemId(SystemID) then begin
                            Rec.ID := 0;
                            Rec."Table ID" := Database::"Document Capturing Header";
                            Rec."No." := DocumentCapturing."Document No.";
                            Rec."Line No." := 0;
                            Rec."File Extension" := 'PDF';
                            Rec."File Type" := Rec."File Type"::PDF;
                        end;
                    end;
                }
                field(fileName; Rec."File Name")
                {
                    Caption = 'Attachment Name';
                    trigger OnValidate()
                    var
                        DotPos: Integer;
                    begin
                        DotPos := StrPos(Rec."File Name", '.');
                        Rec."File Name" := CopyStr(Rec."File Name", 1, DotPos - 1)
                    end;
                }
                field(ContentBase64; ContentBase64)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        VarOutStream: OutStream;
                        Base64CU: Codeunit "Base64 Convert";
                        DocumentInStream: InStream;
                        FileContent: Text;
                    begin
                        TempBlob.CreateOutStream(VarOutStream);
                        Base64CU.FromBase64(ContentBase64, VarOutStream);

                        TempBlob.CreateInStream(DocumentInStream);
                        DocumentInStream.ReadText(FileContent);
                        TempBlob.CreateInStream(DocumentInStream);
                        TempBlob.CreateOutStream(VarOutStream);
                        Base64CU.FromBase64(fileContent, VarOutStream);
                        TempBlob.CreateInStream(DocumentInStream);
                        Rec."Document Reference ID".ImportStream(DocumentInStream, '');
                    end;
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec."No." = '' then
            exit(false);
    end;

    var
        DocumentID: Text;
        SystemID: Guid;
        ContentBase64: Text;
}
