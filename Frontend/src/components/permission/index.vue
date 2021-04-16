<template>
    <fragment v-if="(hasPermission && type=='remove') || type!='remove'">
        <slot :hasPermission="hasPermission"></slot>
    </fragment>
</template>
<script>
    import store from '@/store'
    export default {
      name: "Permission",
      components: {
      },
      
      props:["permissions", "type"],
      data(){
          return {
          }
      },
      computed:{
          hasPermission(){
              const settings = this.$store.getters && this.$store.getters.settings;
              const value = settings.features;
              if (value) {
                const hasPermissions = this.permissions.some(permission => {
                  return value[permission];
                })
                return hasPermissions;
              } else {
                throw new Error(`Please set the operation authority label value`)
              }
          }
      },
      methods:{
      }
    }
</script>
<style>
</style>
