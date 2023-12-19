reportextension 50021 "CarryoutActionMsg-PLan EXt" extends "Carry Out Action Msg. - Plan."
{
    dataset
    {
        // Add changes to dataitems and columns here

    }

    requestpage
    {
        layout
        {
            modify("Assembly Order")
            {
                Visible = false;
            }
            modify("Transfer Order")
            {
                Visible = false;
            }
            modify(CombineTransferOrders)
            {
                Visible = false;
            }



        }

    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'mylayout.rdl';
        }
    }

}