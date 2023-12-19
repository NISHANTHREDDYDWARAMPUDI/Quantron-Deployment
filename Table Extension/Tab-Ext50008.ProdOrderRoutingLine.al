tableextension 50008 ProdOrderRoutingLine extends "Prod. Order Routing Line"
{
    fields
    {
        field(50050; "Work Instruction"; Code[20])
        {
            Caption = 'Work Instruction';
            DataClassification = ToBeClassified;
        }
        field(50051; "Quality Check"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50052; "Quality Spec ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Quality Specification Header"."Spec ID" where(Active = const(true));
        }
        field(50053; "Quality Check Completed"; Boolean)
        {
            Caption = 'Quality Check Completed';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50054; "Send Operation Completion Mail"; Boolean)
        {
            Caption = 'Send Operation Completion Mail';
            DataClassification = ToBeClassified;
        }
        modify("Starting Date-Time")
        {
            trigger OnBeforeValidate()
            var
                QualityCheckErrLbl: Label 'Quality check to be completed before starting the process.';
            begin
                if "Quality Check" and (not "Quality Check Completed") then
                    Error(QualityCheckErrLbl);
            end;
        }
    }
}
