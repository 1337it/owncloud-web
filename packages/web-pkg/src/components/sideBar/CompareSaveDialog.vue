<template>
  <div class="compare-save-dialog oc-width-1-1 oc-flex oc-flex-between oc-flex-middle">
    <span v-if="saved" class="state-indicator oc-flex oc-flex-middle">
      <oc-icon variation="success" name="checkbox-circle" />
      <span v-translate class="changes-saved oc-ml-s">Changes saved</span>
    </span>
    <span v-else class="state-indicator">{{ unsavedChangesText }}</span>
    <div>
      <oc-button :disabled="!unsavedChanges" @click="$emit('revert')">
        <translate>Revert</translate>
      </oc-button>
      <oc-button
        appearance="filled"
        variation="primary"
        :disabled="!unsavedChanges || confirmButtonDisabled"
        @click="$emit('confirm')"
      >
        <translate>Save</translate>
      </oc-button>
    </div>
  </div>
</template>

<script lang="js">
import isEqual from 'lodash-es/isEqual'
import { bus } from 'web-pkg/src/instance'

export default {
  name: 'CompareSaveDialog',
  props: {
    originalObject: {
      type: Object,
      required: true
    },
    compareObject: {
      type: Object,
      required: true
    },
    confirmButtonDisabled: {
      type: Boolean,
      default: () => {
        return false
      }
    },
  },
  data: () => ({
    saved: false,
  }),
  computed: {
    unsavedChanges(){
      return !isEqual(this.originalObject, this.compareObject)
    },
    unsavedChangesText(){
      return this.unsavedChanges ? this.$gettext('Unsaved changes') : this.$gettext('No changes')
    }
  },
  watch: {
    unsavedChanges(){
      if(this.unsavedChanges){
        this.saved = false
      }
    },
    'originalObject.id': function(){
        this.saved = false
    }
  },
  mounted() {
    const savedEventToken = bus.subscribe('sidebar.entity.saved', () => {
      this.saved = true
    })

    this.$on('beforeDestroy', () => bus.unsubscribe('sidebar.entity.saved', savedEventToken))
  }
}
</script>
<style lang="scss" scoped>
.compare-save-dialog {
  background: var(--oc-color-background-highlight);
  flex-flow: row wrap;
}
.state-indicator {
  line-height: 2rem;
}
.changes-saved {
  color: var(--oc-color-swatch-success-default);
}
</style>
