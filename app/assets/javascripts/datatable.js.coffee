class PearsonTable 
  constructor: (el)->
    @el = el
    aoColumns = []

    for th in @el.find("th")
      do (th) ->
        aoColumns.push({bSortable: $(th).data('sortable')}) 
        
    @el.dataTable
                  sPaginationType: "full_numbers"
                  bJQueryUI: true
                  bProcessing: true
                  bServerSide: true
                  iDisplayLength: -1
                  aaSorting: []
                  aoColumns: aoColumns
                  pageLength: 10
                  aLengthMenu: [[10, 25], [10, 25]]
                  sAjaxSource: @el.data('source')
                        
window.PearsonTable = PearsonTable                
                  
