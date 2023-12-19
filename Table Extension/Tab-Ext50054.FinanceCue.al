tableextension 50054 FinanceCue extends "Finance Cue"
{
    fields
    {
        field(50000; "New Documents Capturing"; Integer)
        {
            CalcFormula = Count("Document Capturing Header" WHERE(Status = CONST(New)));
            Caption = 'New Documents Capturing';
            FieldClass = FlowField;
        }
        field(50001; "Validated Documents Capturing"; Integer)
        {
            CalcFormula = Count("Document Capturing Header" WHERE(Status = CONST(Validated)));
            Caption = 'Validated Documents Capturing';
            FieldClass = FlowField;
        }
        field(50002; "Processed Documents Capturing"; Integer)
        {
            CalcFormula = Count("Document Capturing Header" WHERE(Status = CONST(Processed)));
            Caption = 'Processed Documents Capturing';
            FieldClass = FlowField;
        }
        field(50003; "Failed Documents Capturing"; Integer)
        {
            CalcFormula = Count("Document Capturing Header" WHERE(Status = CONST(Failed)));
            Caption = 'Failed Documents Capturing';
            FieldClass = FlowField;
        }
        field(50004; "Rejected Documents Capturing"; Integer)
        {
            CalcFormula = Count("Document Capturing Header" WHERE(Status = CONST(Rejected)));
            Caption = 'Rejected Documents Capturing';
            FieldClass = FlowField;
        }
        field(50005; "Verified Documents Capturing"; Integer)
        {
            CalcFormula = Count("Document Capturing Header" WHERE(Status = CONST(Verified)));
            Caption = 'Verified Documents Capturing';
            FieldClass = FlowField;
        }
        field(50006; "PO Invoices"; Integer)
        {
            CalcFormula = Count("Document Capturing Header" where(Status = CONST("PO Invoice")));
            Caption = 'PO Invoices';
            FieldClass = FlowField;
        }
        field(50007; "Status Date Filter"; Date)
        {
            Caption = 'Status Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }
}
