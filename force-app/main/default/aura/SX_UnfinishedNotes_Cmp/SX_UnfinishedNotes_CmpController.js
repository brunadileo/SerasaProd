({
    youbetModal : function(component, event, helper) {
        if (event.getParam("name") != 'NotasEmAberto') return;
        if(!$('body').hasClass('overflow-hidden')) {
            $('body').addClass('overflow-hidden')
        }
        component.set("v.youbetType", event.getParam("type"));
        var today = new Date();
        //component.set('v.dataDe', "2018-01-01");
        //component.set('v.dataAte', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        //helper.loadResultados(component, event); 
        $('#unfinishedNotesModal').show(200);
    },
    
    closeModal : function (component, event, helper) {
        $('#unfinishedNotesModal').hide(200);
        if($('body').hasClass('overflow-hidden')) {
            $('body').removeClass('overflow-hidden')
        }
        //component.set('v.dataDe', "");
        //component.find("palavraChave").set("v.value", "");
        //component.set("v.lstPoints",null);
        //component.set("v.tableCols", ""); 
    },

    myMember : function(component, event, helper) {
        var action = component.get("c.getMember");
         action.setCallback(this, function(a){ 
            component.set("v.member", a.getReturnValue());
            helper.loadNotasEmAberto(component, event);
        });
        $A.enqueueAction(action); 
    }
    // loadResultados : function(component, event, helper) {
    //     helper.loadResultados(component, event); 
    // },

    // updateColumnSorting: function (cmp, event, helper) {
    //     cmp.set('v.isLoading', true);
    //     // We use the setTimeout method here to simulate the async
    //     // process of the sorting data, so that user will see the
    //     // spinner loading when the data is being sorted.
    //     setTimeout(function() {
    //         var fieldName = event.getParam('fieldName');
    //         var sortDirection = event.getParam('sortDirection');
    //         cmp.set("v.sortedBy", fieldName);
    //         cmp.set("v.sortedDirection", sortDirection);
    //         helper.sortData(cmp, fieldName, sortDirection);
    //         cmp.set('v.isLoading', false);
    //     }, 0);
    // },

    // searchOnEnter : function (component, event, helper) {
    //     if(event.getParams().keyCode == 13){
    //         helper.loadResultados(component, event);
    //     }
    // }
})