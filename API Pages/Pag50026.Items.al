page 50026 Items
{
    APIGroup = 'Items';
    APIPublisher = 'Quantron';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'items';
    EntityName = 'item';
    EntitySetName = 'items';
    InsertAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = true;
    PageType = API;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(itemCategoryCode; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                    trigger OnValidate()
                    begin
                        if ItemCategoryGvar.Get(rec."Item Category Code") then
                            if (ItemCategoryGvar.FG) AND (ItemCategoryGvar."FG No.Series" <> '') then
                                rec."No. Series" := ItemCategoryGvar."FG No.Series";

                    end;

                }
                field(replenishmentSystem; Rec."Replenishment System")
                {
                    Caption = 'Replenishment System';
                }
                field(manufacturerItemNo; Rec."Manufacturer Item No.")
                {
                    Caption = 'Manufacturer Item No.';
                }
                field(manufacturerCode; Rec."Manufacturer Code")
                {
                    Caption = 'Manufacturer Code';
                }
                field(manufacturerName; Rec."Manufacturer Name")
                {
                    Caption = 'Manufacturer Name';
                }

                field(vendorItemNo; Rec."Vendor Item No.")
                {
                    Caption = 'Vendor Item No.';
                }
                field(vendorName; Rec."Vendor Name")
                {
                    Caption = 'Vendor Name';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }

                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(lifecyclestatus; Rec.lifecyclestatus)
                {
                    Caption = 'Life Cycle Status(Life Stage)';
                }
                field(revision; Rec.Revision)
                {
                    Caption = 'Revision';
                }
                field(componentResponsible; Rec.ComponentResponsible)
                {
                    Caption = 'Component Responsible';
                }
                field(ppaprequired; Rec.ppaprequired)
                {
                    Caption = 'PPAP Required';
                }
                field(isirrequired; Rec.isirrequired)
                {
                    Caption = 'IS / IR Required';
                }
                field(homologationrequired; Rec.homologationrequired)
                {
                    Caption = 'Homologation Required';
                }
                field(homologationCerCompLevel; Rec.HomologationCerCompLevel)
                {
                    Caption = 'Homologation Certificate Component Level';
                }
                field(homologationCerSysLevel; Rec.HomologationCerSysLevel)
                {
                    Caption = 'Homologation certificate System Level';
                }
                field(criticality; Rec.criticality)
                {
                    Caption = 'Criticality';
                }
                field(cocrequired; Rec.cocrequired)
                {
                    Caption = 'COC Required';
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit of Measure';
                }
                field(weight; Rec.weight)
                {
                    Caption = 'Weight';
                }
                field(weightuom; Rec.weightuom)
                {
                    Caption = 'Weight UoM';
                }
                field(enditem; Rec.enditem)
                {
                    Caption = 'End Item';
                }

            }

        }


    }

    var
        ItemCategoryGvar: Record "Item Category";
        NoSeriesGvar: Record "No. Series";
        NoseriesMng: Codeunit NoSeriesManagement;




}
