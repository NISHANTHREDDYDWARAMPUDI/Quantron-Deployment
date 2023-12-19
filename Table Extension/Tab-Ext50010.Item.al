tableextension 50010 Item extends Item
{
    fields
    {

        field(50000; "Manufacturer Item No."; Text[100])
        {
            Caption = 'Manufacturer Item No.';
            trigger OnValidate()
            begin
                if Rec."Manufacturer Item No." = '' then
                    exit;
                if "Manufacturer Item No." <> xRec."Manufacturer Item No." then
                    CheckItem("Manufacturer Item No.", "No.");
            end;
        }
        field(50001; "Quality Check"; Boolean)
        {
            Caption = 'Quality Check';
            DataClassification = ToBeClassified;
        }
        field(50002; "Quality Spec ID"; Code[20])
        {
            Caption = 'Quality Spec ID';
            DataClassification = ToBeClassified;
            TableRelation = "Quality Specification Header"."Spec ID" where(Active = const(true), "Specification Type" = const(Incoming));
        }
        field(50003; "QR Code"; Blob)
        {
            Caption = 'QR Code';

        }
        //B2BDNR>>
        field(50010; lifecyclestatus; Enum LifeCycleStatus)
        {
            Caption = 'Life Cycle Status(Life Stage)';
            DataClassification = ToBeClassified;
        }
        field(50011; Revision; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revision';
            trigger OnValidate()
            var
                EventSubs: Codeunit "Event Subscribers";
            begin
                EventSubs.CreateItemRevisionEntry(Rec."No.", Revision);
            end;
        }
        field(50012; ComponentResponsible; Text[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'Component Responsible';
        }
        field(50013; ppaprequired; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'PPAP Required';
        }
        field(50014; isirrequired; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'IS / IR Required';
        }
        field(50015; homologationrequired; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Homologation Required';
        }
        field(50016; criticality; Enum Criticality)
        {
            DataClassification = ToBeClassified;
            caption = 'Criticality';
        }
        field(50017; HomologationCerCompLevel; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Homologation Certificate Component Level';
        }
        field(50018; HomologationCerSysLevel; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Homologation certificate System Level';
        }
        field(50019; cocrequired; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'COC Required';
        }
        field(50020; weight; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Weight';
        }
        field(50021; weightuom; Enum Weight)
        {
            Caption = 'Weight UoM';
            DataClassification = ToBeClassified;
        }
        field(50022; enditem; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Item';
        }
        field(50023; "Maturity State"; Enum "Maturity State")
        {
            DataClassification = ToBeClassified;
            Caption = 'Maturity State';
        }
        field(50024; "Manufacturer Name"; Text[100])
        {
            Caption = 'Manufacturer Name';
            DataClassification = ToBeClassified;
        }
        field(50025; "Unit Volume1"; Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0 : 10;
            MinValue = 0;
        }
        field(50026; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = ToBeClassified;

        }
       
    }
    local procedure CheckItem(ManufItemNo: Text[20]; ItemNo: Code[20])
    var
        ItemRec: Record Item;
        Check: Boolean;
        Finish: Boolean;
        ItemIdentification: Text[100];
        TextString: Text;
        Text002: Label 'This Manufacturer Item No. has already been entered for the following Items:\ %1';
    begin
        Check := true;
        ItemRec.SetCurrentKey("Manufacturer Item No.");
        ItemRec.SetRange("Manufacturer Item No.", ManufItemNo);
        ItemRec.SetFilter("No.", '<>%1', ItemNo);
        if ItemRec.FindSet() then begin
            Check := false;
            Finish := false;
            repeat
                ItemIdentification := ItemRec."No.";
                AppendString(TextString, Finish, ItemIdentification);
            until (ItemRec.Next() = 0) or Finish;
        end;
        if not Check then
            Message(StrSubstNo(Text002, TextString));
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
