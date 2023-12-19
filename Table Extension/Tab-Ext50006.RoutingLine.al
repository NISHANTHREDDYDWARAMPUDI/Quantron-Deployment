tableextension 50006 RoutingLine extends "Routing Line"
{
    fields
    {
        field(50050; "Work Instruction"; Code[20])
        {
            Caption = 'Work Instruction';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50051; "Quality Check"; Boolean)
        {
            Caption = 'Quality Check';
            DataClassification = ToBeClassified;
        }
        field(50052; "Quality Spec ID"; Code[20])
        {
            Caption = 'Quality Spec ID';
            DataClassification = ToBeClassified;
            TableRelation = "Quality Specification Header"."Spec ID" where(Active = const(true), "Specification Type" = const(Production));
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                WorkCenter: Record "Work Center";
            begin
                if not WorkCenter.Get("No.") then
                    "Work Instruction" := ''
                else
                    "Work Instruction" := WorkCenter."Work Instruction";
            end;
        }
        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                if xRec.Type <> Rec.Type then
                    "Work Instruction" := '';
            end;
        }
    }
}
