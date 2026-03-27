<template>
  <div class="dropdown" ref="dropdown">
    <div class="dropdown-toggle text-start border default-padding d-flex justify-content-center align-items-center" :class="props.InputClass" type="button"
      data-bs-toggle="dropdown">
      {{ `${selectedCountry?.flag} ${selectedCountry?.dial_code}` }}
    </div>
    <div class="dropdown-menu">
      <div class="form-group mb-3 px-2">
        <input type="text" ref="SearchBox" class="form-control" placeholder="Search" v-model="searchQuery" @input="search">
      </div>
      <div class="menu-container overflow-auto custom-scrollbar">
        <div v-for="option in filteredcountries" :key="option.id" class="dropdown-item cursor-pointer"
          @click="selectOption(option)">
          {{ option.flag+' '+option.dial_code+' ('+option.code+' - '+option.name+')' }}
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import {ref, computed, onMounted, watch } from 'vue';

const props = defineProps({
    countries: {
        type: Array,
        required: true
    },
    defaultCountry: String,
    InputClass: String,
})

const emit = defineEmits(['update', 'countryCodeUpdate'])
const SearchBox = ref();
const dropdown = ref();

const searchQuery = ref(null);

const filteredcountries = computed(() => {
    if (searchQuery.value) {
      return props.countries.filter((code) => {
        const searchLower = searchQuery.value.toLowerCase();
        let foundMatch = false;
        const checkObject = (obj) => {
          Object.keys(obj).forEach((key) => {
            const value = obj[key];
            if (typeof value === 'object') {
              checkObject(value);
            } else if (typeof value === 'string' || typeof value === 'number') {
              if (value.toString().toLowerCase().includes(searchLower)) {
                foundMatch = true;
              }
            }
          });
        };
        checkObject(code);
        return foundMatch;
      });
    }
    return props.countries;
    });


const selectedCountry = ref({});
const selectOption = (country)=>{
  selectedCountry.value = country
  emit('update', country)
}
watch(()=> props.defaultCountry, ()=>{
    let country = props.countries[0];
    if (props.defaultCountry) {
        country = props.countries.filter(o => o.code.toString().toLowerCase() === props.defaultCountry.toString().toLowerCase())[0]
    }

    selectedCountry.value = country

}, {immediate: true})

onMounted(()=>{
  dropdown.value.addEventListener('shown.bs.dropdown', ()=> SearchBox.value.focus())
});

</script>
<style scoped>
.menu-container{
    max-height: 300px;
    max-width: 280px;
}
</style>
