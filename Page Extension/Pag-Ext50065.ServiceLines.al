pageextension 50065 "Service Lines" extends "Service Lines"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Location Code")
        {
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = All;
            }
            // field("Print On Order"; Rec."Print On Order")
            // {
            //     ApplicationArea = All;
            // }


        }

    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                ServiceheaderRec: Record "Service Header";
                ServLine2: Record "Service Line";
                DimensionErr: Label 'Both %1 & %2 is empty';
                Dimension2Err: Label 'Both %1 & %2 cannot be filled';
            begin
                CurrPage.SetSelectionFilter(ServLine2);
                if ServLine2.FindFirst() then begin
                    ServiceheaderRec.Reset();
                    ServiceheaderRec.SetRange("Document Type", ServiceheaderRec."Document Type"::Order);
                    ServiceheaderRec.SetRange("No.", ServLine2."Document No.");
                    if ServiceheaderRec.FindFirst() then begin
                        ServiceheaderRec.TestField("Posting Date");
                        ServiceheaderRec.TestField("Document Date");
                        ServiceheaderRec.TestField("VAT Reporting Date");
                        if (ServiceheaderRec."Shortcut Dimension 1 Code" = '') and (ServiceheaderRec."Shortcut Dimension 2 Code" = '') then
                            Error(DimensionErr, ServiceheaderRec.FieldCaption("Shortcut Dimension 1 Code"), ServiceheaderRec.FieldCaption("Shortcut Dimension 2 Code"));
                        if (ServiceheaderRec."Shortcut Dimension 1 Code" <> '') and (ServiceheaderRec."Shortcut Dimension 2 Code" <> '') then
                            Error(Dimension2Err, ServiceheaderRec.FieldCaption("Shortcut Dimension 1 Code"), ServiceheaderRec.FieldCaption("Shortcut Dimension 2 Code"));
                    end;
                end;
            end;
        }
        modify(Preview)
        {
            trigger OnBeforeAction()
            var
                ServiceheaderRec: Record "Service Header";
                ServLine2: Record "Service Line";
                DimensionErr: Label 'Both %1 & %2 is empty';
                Dimension2Err: Label 'Both %1 & %2 cannot be filled';
            begin
                CurrPage.SetSelectionFilter(ServLine2);
                if ServLine2.FindFirst() then begin
                    ServiceheaderRec.Reset();
                    ServiceheaderRec.SetRange("Document Type", ServiceheaderRec."Document Type"::Order);
                    ServiceheaderRec.SetRange("No.", ServLine2."Document No.");
                    if ServiceheaderRec.FindFirst() then begin
                        ServiceheaderRec.TestField("Posting Date");
                        ServiceheaderRec.TestField("Document Date");
                        ServiceheaderRec.TestField("VAT Reporting Date");
                        if (ServiceheaderRec."Shortcut Dimension 1 Code" = '') and (ServiceheaderRec."Shortcut Dimension 2 Code" = '') then
                            Error(DimensionErr, ServiceheaderRec.FieldCaption("Shortcut Dimension 1 Code"), ServiceheaderRec.FieldCaption("Shortcut Dimension 2 Code"));
                        if (ServiceheaderRec."Shortcut Dimension 1 Code" <> '') and (ServiceheaderRec."Shortcut Dimension 2 Code" <> '') then
                            Error(Dimension2Err, ServiceheaderRec.FieldCaption("Shortcut Dimension 1 Code"), ServiceheaderRec.FieldCaption("Shortcut Dimension 2 Code"));
                    end;
                end;
            end;
        }
        ////CHB2B14Nov2023<<
        // addafter("Co&mments")
        // {
        //     action(UpdatePrintOnInvoice)
        //     {
        //         ApplicationArea = All;
        //         Image = AdjustEntries;
        //         Caption = 'Update Print on invoice';
        //         trigger OnAction()
        //         var
        //             ServLine: Record "Service Line";
        //         begin
        //             ServLine.CopyFilters(Rec);
        //             if ServLine.FindSet() then
        //                 ServLine.ModifyAll("Print On Order", true);
        //         end;
        //     }
        // }
        // addafter("Co&mments_Promoted")
        // {
        //     actionref(UpdatePrintOnInvoice_promoted; UpdatePrintOnInvoice)
        //     {
        //     }
        // }
        //CHB2B14Nov2023>>
    }
}
