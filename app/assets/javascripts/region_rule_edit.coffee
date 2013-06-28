#= require underscore-min
#= require backbone
#= require backbone.localStorage-min
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
    @save(available: !@get('available'))

    @get('cities').each (city) =>
      city.save(available: @get('available'))

      city.get('areas').each (area) =>
        area.save(available: @get('available'))

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
    @save(available: !@get('available'))

    @get('areas').each (area) =>
      area.save(available: @get('available'))

class RegionRule.Models.Area extends Backbone.RelationalModel
  defaults:
    available: false

  # Toggle the `available` state of this area
  toggle: ->
    @save(available: !@get('available'))

# Collections
class RegionRule.Collections.ProvinceCollection extends Backbone.Collection
  model: RegionRule.Models.Province

  # Save all of the todo items under the `region-rule-backbone` namespace.
  localStorage: new Backbone.LocalStorage('ProvinceCollection', 'session'),

RegionRule.ProvinceList = new RegionRule.Collections.ProvinceCollection

class RegionRule.Collections.CityCollection extends Backbone.Collection
  model: RegionRule.Models.City

  # Save all of the todo items under the `region-rule-backbone` namespace.
  localStorage: new Backbone.LocalStorage('CityCollection', 'session'),


class RegionRule.Collections.AreaCollection extends Backbone.Collection
  model: RegionRule.Models.Area

  # Save all of the todo items under the `region-rule-backbone` namespace.
  localStorage: new Backbone.LocalStorage('AreaCollection', 'session'),

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

  render: ->
    @$el.html(@template(@model.toJSON()))
    @$(".expand").remove() if (@model instanceof RegionRule.Models.Area)
    this

  # Toggle the `"completed"` state of the model.
  toggleAvailable: ->
    this.model.toggle()

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

    $(_province).find("div[cid]").each (i, _city) ->
      city = new RegionRule.Models.City(
        id: $(_city).attr("cid")
        name: $(_city).attr("name")
        available: !!parseInt($(_city).attr("available")))
      province.get("cities").create(city)

      $(_city).find("div[aid]").each (i, _area) ->
        area = new RegionRule.Models.Area(
          id: $(_area).attr("aid")
          name: $(_area).attr("name")
          available: !!parseInt($(_area).attr("available")))
        city.get("areas").create(area)

    RegionRule.ProvinceList.create(province)

  (new RegionRule.Views.ProvinceList).render()

  $('input:submit').click ->

    provinceIds = RegionRule.ProvinceList.where(available: true).
      map (province) -> province.get('id')

    cityList = new RegionRule.Collections.CityCollection
    cityList.fetch()
    cityIds = cityList.where(available: true).map (city) ->
      city.get('id')

    areaList = new RegionRule.Collections.AreaCollection
    areaList.fetch()
    areaIds = areaList.where(available: true).map (area) ->
      area.get('id')

    $provinceIds.val(provinceIds.join(','))
    $cityIds.val(cityIds.join(','))
    $areaIds.val(areaIds.join(','))

    console.log(provinceIds.length)
    console.log(cityIds.length)
    console.log(areaIds.length)
