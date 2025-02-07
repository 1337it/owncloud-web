<template>
  <div id="user-edit-panel" class="oc-mt-xl">
    <UserInfoBox :user="user" />
    <div id="user-edit-form" class="oc-background-highlight oc-p-m">
      <div>
        <oc-text-input
          v-model="editUser.displayName"
          class="oc-mb-s"
          :label="$gettext('First and last name')"
          :error-message="formData.displayName.errorMessage"
          :fix-message-line="true"
          @input="validateDisplayName"
        />
        <oc-text-input
          v-model="editUser.mail"
          class="oc-mb-s"
          :label="$gettext('Email')"
          :error-message="formData.email.errorMessage"
          type="email"
          :fix-message-line="true"
          @change="validateEmail"
        />
        <oc-text-input
          v-model="editUser.passwordProfile.password"
          class="oc-mb-s"
          :label="$gettext('Password')"
          type="password"
          :fix-message-line="true"
          default-value="●●●●●●●●"
        />
        <div class="oc-mb-s">
          <oc-select
            v-model="editUser.role"
            :label="$gettext('Role')"
            option-label="displayName"
            :options="roles"
            :clearable="false"
          />
          <div class="oc-text-input-message"></div>
        </div>
        <quota-select
          v-if="showQuota"
          class="oc-mb-s"
          :key="'quota-select-' + user.id"
          :title="$gettext('Personal quota')"
          :total-quota="editUser.drive.quota.total || 0"
          @selectedOptionChange="changeSelectedQuotaOption"
        />
        <p v-else v-translate class="oc-m-rm">
          To set an individual quota, the user needs to have logged in once.
        </p>
      </div>
      <compare-save-dialog
        class="edit-compare-save-dialog oc-mb-l"
        :original-object="user"
        :compare-object="editUser"
        :confirm-button-disabled="invalidFormData"
        @revert="revertChanges"
        @confirm="$emit('confirm', editUser)"
      ></compare-save-dialog>
    </div>
  </div>
</template>
<script>
import * as EmailValidator from 'email-validator'
import UserInfoBox from './UserInfoBox.vue'
import CompareSaveDialog from 'web-pkg/src/components/sideBar/CompareSaveDialog.vue'
import QuotaSelect from 'web-pkg/src/components/QuotaSelect.vue'
import { cloneDeep } from 'lodash-es'

export default {
  name: 'EditPanel',
  components: {
    UserInfoBox,
    CompareSaveDialog,
    QuotaSelect
  },
  props: {
    user: {
      type: Object,
      required: true
    },
    roles: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      editUser: {},
      formData: {
        displayName: {
          errorMessage: '',
          valid: true
        },
        email: {
          errorMessage: '',
          valid: true
        }
      }
    }
  },
  computed: {
    invalidFormData() {
      return Object.values(this.formData)
        .map((v) => !!v.valid)
        .includes(false)
    },
    showQuota() {
      return this.editUser.drive
    }
  },
  watch: {
    user: {
      handler: function () {
        this.editUser = cloneDeep(this.user)
      },
      deep: true,
      immediate: true
    }
  },
  methods: {
    changeSelectedQuotaOption(option) {
      this.editUser.drive.quota.total = option.value
    },
    validateDisplayName() {
      this.formData.displayName.valid = false

      if (this.editUser.displayName.trim() === '') {
        this.formData.displayName.errorMessage = this.$gettext('Display name cannot be empty')
        return false
      }

      this.formData.displayName.errorMessage = ''
      this.formData.displayName.valid = true
      return true
    },
    validateEmail() {
      this.formData.email.valid = false

      if (!EmailValidator.validate(this.editUser.mail)) {
        this.formData.email.errorMessage = this.$gettext('Please enter a valid email')
        return false
      }

      this.formData.email.errorMessage = ''
      this.formData.email.valid = true
      return true
    },
    revertChanges() {
      this.editUser = this.user
      Object.values(this.formData).forEach((formDataValue) => {
        formDataValue.valid = true
        formDataValue.errorMessage = ''
      })
    }
  }
}
</script>

<style lang="scss">
#user-edit-panel {
  #user-edit-form {
    border-radius: 5px;
  }
}
</style>
