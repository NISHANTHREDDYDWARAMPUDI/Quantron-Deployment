tableextension 50007 RoutingTool extends "Routing Tool"
{
    fields
    {
        field(50000; "Type"; Enum RoutingToolType)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }
        modify("No.")
        {
            TableRelation = if (Type = const(Item)) Item else
            if (Type = const("Fixed Asset")) "Fixed Asset";
            trigger OnAfterValidate()
            begin
                UpdateDescription(Type, "No.");
            end;
        }
    }
    local procedure UpdateDescription(TypeVar: Enum RoutingToolType; No: Code[20])
    var
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
    begin
        case TypeVar of
            TypeVar::"Fixed Asset":
                begin
                    FixedAsset.Get(No);
                    Description := FixedAsset.Description;
                end;
            TypeVar::Item:
                begin
                    Item.Get(No);
                    Description := Item.Description;
                end;
        end;
    end;
}
