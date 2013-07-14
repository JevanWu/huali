#= require underscore-min
#= require backbone
#= require backbone-relational

window.RegionRule =
  Collections: {}
  Models: {}
  Views: {}
  Templates: {}

# Models
class RegionRule.Models.Province extends Backbone.RelationalModel
  defaults:
    available: false

  relations: [{
    type: Backbone.HasMany
    key: 'cities'
    relatedModel: 'RegionRule.Models.City'
    collectionType: 'RegionRule.Collections.CityCollection'
    reverseRelation:
      key: 'province'
      includeInJSON: 'id'
  }]

  # Toggle the `available` state of this province and its cities and their areas
  toggle: ->
    @set(available: !@get('available'))

    @get('cities').each (city) =>
      city.set(available: @get('available'))

      city.get('areas').each (area) =>
        area.set(available: @get('available'))

  indeterminate: ->
    if (@get('cities').every (city) -> city.get('available')) || (@get('cities').every (city) -> !city.get('available'))
      false
    else
      true

  all_cities_available: ->
    @get('cities').every (city) -> city.get('available')

  all_cities_unavailable: ->
    @get('cities').every (city) -> !city.get('available')

class RegionRule.Models.City extends Backbone.RelationalModel
  defaults:
    available: false

  relations: [{
    type: Backbone.HasMany
    key: 'areas'
    relatedModel: 'RegionRule.Models.Area'
    collectionType: 'RegionRule.Collections.AreaCollection'
    reverseRelation:
      key: 'city'
      includeInJSON: 'id'
  }]

  # Toggle the `available` state of this city and its areas
  toggle: ->
    @set(available: !@get('available'))

    @get('areas').each (area) =>
      area.set(available: @get('available'))

  indeterminate: ->
    if (@get('areas').every (area) -> area.get('available')) || (@get('areas').every (area) -> !area.get('available'))
      false
    else
      true

  all_areas_available: ->
    @get('areas').every (area) -> area.get('available')

  all_areas_unavailable: ->
    @get('areas').every (area) -> !area.get('available')

class RegionRule.Models.Area extends Backbone.RelationalModel
  defaults:
    available: false

  # Toggle the `available` state of this area
  toggle: ->
    @set(available: !@get('available'))

# Collections
class RegionRule.Collections.ProvinceCollection extends Backbone.Collection
  model: RegionRule.Models.Province

class RegionRule.Collections.CityCollection extends Backbone.Collection
  model: RegionRule.Models.City

class RegionRule.Collections.AreaCollection extends Backbone.Collection
  model: RegionRule.Models.Area

# Collections in memory
RegionRule.ProvinceList = new RegionRule.Collections.ProvinceCollection
RegionRule.CityList = new RegionRule.Collections.CityCollection
RegionRule.AreaList = new RegionRule.Collections.AreaCollection

# Templates
RegionRule.Templates.region_template = """
  <div class="view">
    <label>
      <input class="toggle" type="checkbox" <%= available ? "checked" : ''%> />
      <%- name %>
    </label>
    <button id="<%= id %>" class='expand'>+</button>
  </div>
"""

# Views
class RegionRule.Views.Region extends Backbone.View
  tagName: 'div'

  # Cache the template function for a single item.
  template: _.template(RegionRule.Templates.region_template)

  events:
    'click .toggle': 'toggleAvailable'
    'click .expand': 'expandChild'

  initialize: ->
    @listenTo(@model, 'setToggleState', this.setToggleState)

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$(".expand").remove() if (@model instanceof RegionRule.Models.Area)
    @setIndeterminate() unless (@model instanceof RegionRule.Models.Area)
    this

  # Toggle the `"completed"` state of the model.
  toggleAvailable: ->
    @model.toggle()
    @toggleParent()

  # Trigger events to check indeterminate of parent
  toggleParent: ->
    if @model instanceof RegionRule.Models.City
      @model.get('province').trigger('setToggleState')
    if @model instanceof RegionRule.Models.Area
      @model.get('city').trigger('setToggleState')

  setToggleState: ->
    if @model instanceof RegionRule.Models.Province
      if @model.all_cities_available()
        @$('.toggle').prop('checked', true)
        @model.set('available', true)
      else if @model.all_cities_unavailable()
        @$('.toggle').prop('checked', false)
        @model.set('available', false)
    else if @model instanceof RegionRule.Models.City
      if @model.all_areas_available()
        @$('.toggle').prop('checked', true)
        @model.set('available', true)
      else if @model.all_areas_unavailable()
        @$('.toggle').prop('checked', false)
        @model.set('available', false)
      @toggleParent()

    @setIndeterminate()

  setIndeterminate: ->
    @$('.toggle').prop('indeterminate', @model.indeterminate())

  expandChild: (event) ->
    if @model instanceof RegionRule.Models.Province
      cityList = new RegionRule.Views.CityList(@model)
      cityList.render()
    if @model instanceof RegionRule.Models.City
      areaList = new RegionRule.Views.AreaList(@model)
      areaList.render()

    event.preventDefault()

class RegionRule.Views.ProvinceList extends Backbone.View
  el: '#province_list'

  render: ->
    RegionRule.ProvinceList.each (province) =>
      regionView = new RegionRule.Views.Region(model: province)
      @$el.append(regionView.render().el)

class RegionRule.Views.CityList extends Backbone.View
  initialize: (province) ->
    @province = province
    @cities = province.get('cities')

    @$el.attr("title", "#{@province.get('name')}的城市")

  tagName: 'ul'

  dialog: ->
    $(@el).dialog(
      autoOpen: false
      width: 380
      modal: true
      close: =>
        @remove()
    ).dialog("open")

  render: ->
    @cities.each (city) =>
      regionView = new RegionRule.Views.Region(model: city)
      @$el.append(regionView.render().el)

    @dialog()

class RegionRule.Views.AreaList extends Backbone.View
  initialize: (city) ->
    @city = city
    @areas = city.get('areas')

    @$el.attr("title", "#{@city.get('name')}的地区")

  tagName: 'ul'

  dialog: ->
    $(@el).dialog(
      autoOpen: false
      modal: true
      close: =>
        @remove()
    ).dialog("open")

  render: ->
    @areas.each (area) =>
      regionView = new RegionRule.Views.Region(model: area)
      @$el.append(regionView.render().el)

    @dialog()

$ ->
  $provinceIds = $("#region_rule_province_ids")
  $cityIds = $("#region_rule_city_ids")
  $areaIds = $("#region_rule_area_ids")

  $(".provinces").find("div[pid]").each (i, _province) ->
    province = new RegionRule.Models.Province(
      id: $(_province).attr("pid")
      name: $(_province).attr("name")
      available: !!parseInt($(_province).attr("available")))

    RegionRule.ProvinceList.add(province)

    $(_province).find("div[cid]").each (i, _city) ->
      city = new RegionRule.Models.City(
        id: $(_city).attr("cid")
        name: $(_city).attr("name")
        available: !!parseInt($(_city).attr("available")))
      province.get("cities").add(city)

      RegionRule.CityList.add(city)

      $(_city).find("div[aid]").each (i, _area) ->
        area = new RegionRule.Models.Area(
          id: $(_area).attr("aid")
          name: $(_area).attr("name")
          available: !!parseInt($(_area).attr("available")))
        city.get("areas").add(area)

        RegionRule.AreaList.add(area)


  (new RegionRule.Views.ProvinceList).render()

  $('input:submit').click ->

    provinceIds = RegionRule.ProvinceList.where(available: true).
      map (province) -> province.get('id')


    cityIds = RegionRule.CityList.where(available: true).map (city) ->
      city.get('id')

    areaIds = RegionRule.AreaList.where(available: true).map (area) ->
      area.get('id')

    $provinceIds.val(provinceIds.join(','))
    $cityIds.val(cityIds.join(','))
    $areaIds.val(areaIds.join(','))
