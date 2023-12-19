tableextension 50040 WorkCenter extends "Work Center"
{
    fields
    {
        field(50000; "Work Instruction"; Code[20])
        {
            Caption = 'Work Instruction';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RoutingLine: Record "Routing Line";
                RoutingHeader: Record "Routing Header";
                ConfirmTxt: Label 'Do you want to change the work instruction.? This workcenter no. has already been entered for the following routing lines:\ %1';
            begin
                if xRec."Work Instruction" = Rec."Work Instruction" then
                    exit;
                if not Confirm(StrSubstNo(ConfirmTxt, CheckRouting(Rec."No.")), false) then begin
                    Rec."Work Instruction" := xRec."Work Instruction";
                    exit;
                end;
                RoutingLine.Reset();
                RoutingLine.SetCurrentKey("Routing No.", "Version Code", "Operation No.");
                RoutingLine.SetRange("Work Center No.", Rec."No.");
                if RoutingLine.FindSet() then
                    repeat
                        RoutingHeader.Get(RoutingLine."Routing No.");
                        RoutingHeader.Validate(Status, RoutingHeader.Status::"Under Development");
                        RoutingHeader.Modify(true);
                    until (RoutingLine.Next() = 0)
            end;
        }
    }
    local procedure CheckRouting(WorkCenterNo: Code[20]): Text
    var
        RoutingLines: Record "Routing Line";
        Finish: Boolean;
        RoutingIdentification: Text[100];
        PrevRoutingLine: Code[20];
        TextString: Text;
    begin
        RoutingLines.Reset();
        RoutingLines.SetCurrentKey("Routing No.", "Version Code", "Operation No.");
        RoutingLines.SetRange("Work Center No.", WorkCenterNo);
        if RoutingLines.FindSet() then begin
            Finish := false;
            repeat
                if PrevRoutingLine <> RoutingLines."Routing No." then begin
                    RoutingIdentification := RoutingLines."Routing No.";
                    AppendString(TextString, Finish, RoutingIdentification);
                end;
                PrevRoutingLine := RoutingLines."Routing No.";
            until (RoutingLines.Next() = 0) or Finish;
        end;
        exit(TextString);
    end;

    local procedure AppendString(var String: Text; var Finish: Boolean; AppendText: Text)
    begin
        case true of
            Finish:
                exit;
            String = '':
                String := AppendText;
            StrLen(String) + StrLen(AppendText) + 5 <= 250:
                String += ', ' + AppendText;
            else begin
                String += '...';
                Finish := true;
            end;
        end;
    end;
}
