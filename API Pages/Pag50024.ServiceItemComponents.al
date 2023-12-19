page 50024 ServiceItemComponents
{
    APIGroup = 'Service';
    APIPublisher = 'Quantron';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'serviceitemcomponents';
    EntityName = 'serviceitemcomponent';
    EntitySetName = 'serviceitemcomponents';
    PageType = API;
    SourceTable = "Service Item Component";
    ODataKeyFields = "No.";
    DelayedInsert = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(active; Rec.Active)
                {
                    Caption = 'Active';
                }
                field(dateInstalled; Rec."Date Installed")
                {
                    Caption = 'Date Installed';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(fromLineNo; Rec."From Line No.")
                {
                    Caption = 'From Line No.';
                }
                field(lastDateModified; Rec."Last Date Modified")
                {
                    Caption = 'Last Date Modified';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(parentServiceItemNo; Rec."Parent Service Item No.")
                {
                    Caption = 'Parent Service Item No.';
                }
                field(serialNo; Rec."Serial No.")
                {
                    Caption = 'Serial No.';
                }
                field(serviceOrderNo; Rec."Service Order No.")
                {
                    Caption = 'Service Order No.';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
            }
        }
    }
}
