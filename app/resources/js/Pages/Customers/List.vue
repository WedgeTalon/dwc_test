<script setup>
import { ref, watch, onMounted } from 'vue';
import { defineProps } from 'vue';
import axios from 'axios';
import { Head } from '@inertiajs/vue3';

const headers = [
    { title: 'Account Number', value: 'account_number', sortable: true },
    { title: 'Name', value: 'customer_name', sortable: true },
    { title: 'Email', value: 'email', sortable: true },
    { title: 'Phone', value: 'phone', sortable: true },
    { title: 'Date Added', value: 'created_at', sortable: true },
    { title: 'Actions', value: 'actions', sortable: false },
];

const props = defineProps({
    customers: {
        type: Array,
        required: true
    }
});

const selectedCustomer = ref(null);
const dialog = ref(false);
const search = ref('');
const loading = ref({});
const snackbar = ref(false);
const snackbarMessage = ref('');
const snackbarColor = ref('');

const businessTypes = ['Corporation', 'LLC', 'Sole Proprietor', 'Other'];
const shipmentDays = ['M', 'T', 'W', 'R', 'F'];

const sameAsBilling = ref(true);

const newCustomer = ref({
    customer_name: '',
    email: '',
    phone: '',
    billing_address_1: '',
    billing_address_2: '',
    billing_city: '',
    billing_state: '',
    billing_zip: '',
    shipping_address_1: '',
    shipping_address_2: '',
    shipping_city: '',
    shipping_state: '',
    shipping_zip: '',
    business_type: 'Corporation', // Default to Corporation
    shipment_day: ['M', 'T', 'W', 'R', 'F'] // Default to all 5 days
});

const formLoading = ref(false);
const formErrors = ref({});

const stateAbbreviations = ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'];

watch(() => newCustomer.value.billing_address_1, (newVal) => {
    if (sameAsBilling.value) newCustomer.value.shipping_address_1 = newVal;
});
watch(() => newCustomer.value.billing_address_2, (newVal) => {
    if (sameAsBilling.value) newCustomer.value.shipping_address_2 = newVal;
});
watch(() => newCustomer.value.billing_city, (newVal) => {
    if (sameAsBilling.value) newCustomer.value.shipping_city = newVal;
});
watch(() => newCustomer.value.billing_state, (newVal) => {
    if (sameAsBilling.value) newCustomer.value.shipping_state = newVal;
});
watch(() => newCustomer.value.billing_zip, (newVal) => {
    if (sameAsBilling.value) newCustomer.value.shipping_zip = newVal;
});

function showDetails(customer) {
    selectedCustomer.value = customer;
    dialog.value = true;
}

async function deleteCustomer(customerId) {
    loading.value = { ...loading.value, [customerId]: true };
    try {
        await axios.delete(`/api/v1/customers/${customerId}`);
        // Remove the customer from the local list
        props.customers = props.customers.filter(customer => customer.id !== customerId);
        snackbarMessage.value = 'Customer deleted successfully';
        snackbarColor.value = 'success';
        snackbar.value = true;
    } catch (error) {
        console.error('Failed to delete customer:', error);
        snackbarMessage.value = 'Failed to delete customer';
        snackbarColor.value = 'error';
        snackbar.value = true;
    } finally {
        loading.value = { ...loading.value, [customerId]: false };
    }
}

async function updateCustomer() {
    selectedCustomer.value.phone = formatPhone(selectedCustomer.value.phone);
    if (!validateForm(selectedCustomer.value)) return;

    loading.value = { ...loading.value, [selectedCustomer.value.id]: true };
    try {
        await axios.put(`/api/v1/customers/${selectedCustomer.value.id}`, selectedCustomer.value);
        snackbarMessage.value = 'Customer updated successfully';
        snackbarColor.value = 'success';
        snackbar.value = true;
    } catch (error) {
        console.error('Failed to update customer:', error);
        if (error.response && error.response.data.errors) {
            formErrors.value = error.response.data.errors;
        } else {
            snackbarMessage.value = 'Failed to update customer';
            snackbarColor.value = 'error';
            snackbar.value = true;
        }
    } finally {
        loading.value = { ...loading.value, [selectedCustomer.value.id]: false };
        dialog.value = false;
    }
}

async function addCustomer() {
    newCustomer.value.phone = formatPhone(newCustomer.value.phone);
    if (!validateForm(newCustomer.value)) return;

    formLoading.value = true;
    try {
        const response = await axios.post('/api/v1/customers', newCustomer.value);
        // Trigger reactivity update
        props.customers = [...props.customers, response.data];
        snackbarMessage.value = 'Customer added successfully';
        snackbarColor.value = 'success';
        snackbar.value = true;
        // Reset the form
        resetForm();
    } catch (error) {
        console.error('Failed to add customer:', error);
        if (error.response && error.response.data.errors) {
            formErrors.value = error.response.data.errors;
        } else {
            snackbarMessage.value = 'Failed to add customer';
            snackbarColor.value = 'error';
            snackbar.value = true;
        }
    } finally {
        formLoading.value = false;
    }
}

function resetForm() {
    Object.keys(newCustomer.value).forEach(key => newCustomer.value[key] = '');
    sameAsBilling.value = true;
}

function validateForm(customer) {
    formErrors.value = {};

    if (!customer.customer_name) formErrors.value.customer_name = 'Name is required';
    if (!customer.email || !/\S+@\S+\.\S+/.test(customer.email)) formErrors.value.email = 'Valid Email is required';
    if (!customer.phone || !/^\(\d{3}\) \d{3}-\d{4}$/.test(customer.phone)) formErrors.value.phone = 'Valid Phone is required';
    if (!customer.billing_address_1) formErrors.value.billing_address_1 = 'Billing Address 1 is required';
    if (!customer.billing_city) formErrors.value.billing_city = 'Billing City is required';
    if (!customer.billing_state || !stateAbbreviations.includes(customer.billing_state)) formErrors.value.billing_state = 'Valid Billing State is required';
    if (!customer.billing_zip) formErrors.value.billing_zip = 'Billing Zip is required';
    if (!sameAsBilling.value) {
        if (!customer.shipping_address_1) formErrors.value.shipping_address_1 = 'Shipping Address 1 is required';
        if (!customer.shipping_city) formErrors.value.shipping_city = 'Shipping City is required';
        if (!customer.shipping_state || !stateAbbreviations.includes(customer.shipping_state)) formErrors.value.shipping_state = 'Valid Shipping State is required';
        if (!customer.shipping_zip) formErrors.value.shipping_zip = 'Shipping Zip is required';
    }
    if (!customer.business_type) formErrors.value.business_type = 'Business Type is required';
    if (!customer.shipment_day.length) formErrors.value.shipment_day = 'At least one Shipment Day is required';

    return Object.keys(formErrors.value).length === 0;
}

function formatPhone(phone) {
    const cleaned = ('' + phone).replace(/\D/g, '');
    const match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
    if (match) {
        return `(${match[1]}) ${match[2]}-${match[3]}`;
    }
    return phone;
}
</script>

<template>
    <Head title="Customer Management" />
    <v-app>
        <v-main>
            <v-container>
                <h1 class="text-2xl font-bold mb-4">DWC - Customer Management</h1>
                <v-card class="mb-4 pa-4" :class="{ 'opacity-50': formLoading }">
                    <v-card-title class="add-customer-header">
                        Add Customer
                    </v-card-title>
                    <v-form>
                        <v-row dense>
                            <v-col cols="12" md="6" sm="12" class="py-1">
                                <v-text-field
                                    label="Name"
                                    v-model="newCustomer.customer_name"
                                    :disabled="formLoading"
                                    :error-messages="formErrors.customer_name"
                                    density="compact"
                                ></v-text-field>
                            </v-col>
                            <v-col cols="12" md="6" sm="12" class="py-1">
                                <v-text-field
                                    label="Email"
                                    v-model="newCustomer.email"
                                    :disabled="formLoading"
                                    :error-messages="formErrors.email"
                                    density="compact"
                                ></v-text-field>
                            </v-col>
                            <v-col cols="12" md="6" sm="12" class="py-1">
                                <v-text-field
                                    label="Phone"
                                    v-model="newCustomer.phone"
                                    :disabled="formLoading"
                                    :error-messages="formErrors.phone"
                                    density="compact"
                                ></v-text-field>
                            </v-col>
                        </v-row>
                        <v-row dense>
                            <v-col cols="12" md="6" sm="12" class="py-1">
                                <v-select
                                    label="Type of Business"
                                    v-model="newCustomer.business_type"
                                    :items="businessTypes"
                                    :disabled="formLoading"
                                    :error-messages="formErrors.business_type"
                                    density="compact"
                                ></v-select>
                            </v-col>
                            <v-col cols="12" md="6" sm="12" class="py-1">
                                <v-select
                                    label="Preferred Days of Receiving Shipments"
                                    v-model="newCustomer.shipment_day"
                                    :items="shipmentDays"
                                    multiple
                                    :disabled="formLoading"
                                    :error-messages="formErrors.shipment_day"
                                    density="compact"
                                ></v-select>
                            </v-col>
                        </v-row>
                        <v-row dense>
                            <v-col cols="12" class="py-1">
                                <h3 class="font-bold">Billing Address</h3>
                            </v-col>
                            <v-col cols="12" md="6" sm="12" class="py-1">
                                <v-text-field
                                    label="Billing Address 1"
                                    v-model="newCustomer.billing_address_1"
                                    :disabled="formLoading"
                                    :error-messages="formErrors.billing_address_1"
                                    density="compact"
                                ></v-text-field>
                            </v-col>
                            <v-col cols="12" md="6" sm="12" class="py-1">
                                <v-text-field
                                    label="Billing Address 2"
                                    v-model="newCustomer.billing_address_2"
                                    :disabled="formLoading"
                                    density="compact"
                                ></v-text-field>
                            </v-col>
                            <v-col cols="12" md="4" sm="12" class="py-1">
                                <v-text-field
                                    label="Billing City"
                                    v-model="newCustomer.billing_city"
                                    :disabled="formLoading"
                                    :error-messages="formErrors.billing_city"
                                    density="compact"
                                ></v-text-field>
                            </v-col>
                            <v-col cols="12" md="4" sm="12" class="py-1">
                                <v-autocomplete
                                    label="Billing State"
                                    v-model="newCustomer.billing_state"
                                    :items="stateAbbreviations"
                                    :disabled="formLoading"
                                    :error-messages="formErrors.billing_state"
                                    density="compact"
                                ></v-autocomplete>
                            </v-col>
                            <v-col cols="12" md="4" sm="12" class="py-1">
                                <v-text-field
                                    label="Billing Zip"
                                    v-model="newCustomer.billing_zip"
                                    :disabled="formLoading"
                                    :error-messages="formErrors.billing_zip"
                                    density="compact"
                                ></v-text-field>
                            </v-col>
                            <v-col cols="12" class="d-flex align-center py-1">
                                <h3 class="font-bold mr-4">Shipping Address</h3>
                                <v-checkbox
                                    v-model="sameAsBilling"
                                    label="Same as billing address"
                                    :disabled="formLoading"
                                    hide-details
                                    density="compact"
                                    class="mt-0"
                                ></v-checkbox>
                            </v-col>
                            <template v-if="!sameAsBilling">
                                <v-col cols="12" md="6" sm="12" class="py-1">
                                    <v-text-field
                                        label="Shipping Address 1"
                                        v-model="newCustomer.shipping_address_1"
                                        :disabled="formLoading"
                                        :error-messages="formErrors.shipping_address_1"
                                        density="compact"
                                    ></v-text-field>
                                </v-col>
                                <v-col cols="12" md="6" sm="12" class="py-1">
                                    <v-text-field
                                        label="Shipping Address 2"
                                        v-model="newCustomer.shipping_address_2"
                                        :disabled="formLoading"
                                        density="compact"
                                    ></v-text-field>
                                </v-col>
                                <v-col cols="12" md="4" sm="12" class="py-1">
                                    <v-text-field
                                        label="Shipping City"
                                        v-model="newCustomer.shipping_city"
                                        :disabled="formLoading"
                                        :error-messages="formErrors.shipping_city"
                                        density="compact"
                                    ></v-text-field>
                                </v-col>
                                <v-col cols="12" md="4" sm="12" class="py-1">
                                    <v-autocomplete
                                        label="Shipping State"
                                        v-model="newCustomer.shipping_state"
                                        :items="stateAbbreviations"
                                        :disabled="formLoading"
                                        :error-messages="formErrors.shipping_state"
                                        density="compact"
                                    ></v-autocomplete>
                                </v-col>
                                <v-col cols="12" md="4" sm="12" class="py-1">
                                    <v-text-field
                                        label="Shipping Zip"
                                        v-model="newCustomer.shipping_zip"
                                        :disabled="formLoading"
                                        :error-messages="formErrors.shipping_zip"
                                        density="compact"
                                    ></v-text-field>
                                </v-col>
                            </template>
                        </v-row>
                        <v-row class="mt-2 justify-end">
                            <v-col cols="12" md="auto" class="py-1">
                                <v-btn color="secondary" @click="resetForm" :disabled="formLoading" small>Reset Form</v-btn>
                            </v-col>
                            <v-col cols="12" md="auto" class="py-1">
                                <v-btn color="primary" @click="addCustomer" :loading="formLoading" small>
                                    <template v-if="formLoading">
                                        <v-progress-circular indeterminate size="20" color="white"></v-progress-circular>
                                    </template>
                                    <template v-else>
                                        Add Customer
                                    </template>
                                </v-btn>
                            </v-col>
                        </v-row>
                    </v-form>
                </v-card>
                <v-data-table
                    :headers="headers"
                    :items="customers"
                    :sort-by="[{ key: 'created_at', order: 'desc' }]"
                    class="elevation-1"
                >
                    <template v-slot:top>
                        <v-toolbar flat>
                            <v-toolbar-title class="customer-list-header">Customer List</v-toolbar-title>
                            <v-divider class="mx-4" inset vertical></v-divider>
                            <v-spacer></v-spacer>
                        </v-toolbar>
                    </template>
                    <template v-slot:item.account_number="{ item }">
                        {{ item.account_number }}
                    </template>
                    <template v-slot:item.customer_name="{ item }">
                        {{ item.customer_name }}
                    </template>
                    <template v-slot:item.email="{ item }">
                        {{ item.email }}
                    </template>
                    <template v-slot:item.phone="{ item }">
                        {{ item.phone }}
                    </template>
                    <template v-slot:item.created_at="{ item }">
                        {{ new Date(item.created_at).toLocaleDateString() }}
                    </template>
                    <template v-slot:item.actions="{ item }">
                        <v-icon
                            @click="showDetails(item)"
                            class="cursor-pointer"
                            :disabled="loading[item.id]"
                        >
                            mdi-text-box-outline
                        </v-icon>
                        <v-icon
                            @click="deleteCustomer(item.id)"
                            class="cursor-pointer ml-2"
                            :disabled="loading[item.id]"
                        >
                            <template v-if="loading[item.id]">
                                <v-progress-circular indeterminate size="20"></v-progress-circular>
                            </template>
                            <template v-else>
                                mdi-delete
                            </template>
                        </v-icon>
                    </template>
                    <template v-slot:item="{ item, index }">
                        <tr :class="{ 'opacity-50': loading[item.id] }">
                            <td>{{ item.account_number }}</td>
                            <td>{{ item.customer_name }}</td>
                            <td>{{ item.email }}</td>
                            <td>{{ item.phone }}</td>
                            <td>{{ new Date(item.created_at).toLocaleDateString() }}</td>
                            <td>
                                <v-icon
                                    @click="showDetails(item)"
                                    class="cursor-pointer"
                                    :disabled="loading[item.id]"
                                >
                                    mdi-text-box-outline
                                </v-icon>
                                <v-icon
                                    @click="deleteCustomer(item.id)"
                                    class="cursor-pointer ml-2"
                                    :disabled="loading[item.id]"
                                >
                                    <template v-if="loading[item.id]">
                                        <v-progress-circular indeterminate size="20"></v-progress-circular>
                                    </template>
                                    <template v-else>
                                        mdi-delete
                                    </template>
                                </v-icon>
                            </td>
                        </tr>
                    </template>
                </v-data-table>

                <v-dialog v-model="dialog" max-width="600px">
                    <v-card>
                        <v-card-title>
                            <span class="headline">Customer Details</span>
                        </v-card-title>
                        <v-card-text v-if="selectedCustomer">
                            <v-form>
                                <div>
                                    <h3 class="font-bold">Account Number</h3>
                                    <p>{{ selectedCustomer.account_number }}</p>
                                </div>
                                <v-text-field
                                    label="Name"
                                    v-model="selectedCustomer.customer_name"
                                    :error-messages="formErrors.customer_name"
                                    :disabled="loading[selectedCustomer.id]"
                                    density="compact"
                                ></v-text-field>
                                <v-text-field
                                    label="Email"
                                    v-model="selectedCustomer.email"
                                    :error-messages="formErrors.email"
                                    :disabled="loading[selectedCustomer.id]"
                                    density="compact"
                                ></v-text-field>
                                <v-text-field
                                    label="Phone"
                                    v-model="selectedCustomer.phone"
                                    :error-messages="formErrors.phone"
                                    :disabled="loading[selectedCustomer.id]"
                                    density="compact"
                                ></v-text-field>
                                <v-select
                                    label="Type of Business"
                                    v-model="selectedCustomer.business_type"
                                    :items="businessTypes"
                                    :error-messages="formErrors.business_type"
                                    density="compact"
                                    :disabled="loading[selectedCustomer.id]"
                                ></v-select>
                                <v-select
                                    label="Preferred Days of Receiving Shipments"
                                    v-model="selectedCustomer.shipment_day"
                                    :items="shipmentDays"
                                    multiple
                                    :error-messages="formErrors.shipment_day"
                                    density="compact"
                                    :disabled="loading[selectedCustomer.id]"
                                ></v-select>
                                <div>
                                    <h3 class="font-bold">Billing Address</h3>
                                    <v-text-field
                                        label="Address 1"
                                        v-model="selectedCustomer.billing_address_1"
                                        :error-messages="formErrors.billing_address_1"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-text-field>
                                    <v-text-field
                                        label="Address 2"
                                        v-model="selectedCustomer.billing_address_2"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-text-field>
                                    <v-text-field
                                        label="City"
                                        v-model="selectedCustomer.billing_city"
                                        :error-messages="formErrors.billing_city"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-text-field>
                                    <v-autocomplete
                                        label="State"
                                        v-model="selectedCustomer.billing_state"
                                        :items="stateAbbreviations"
                                        :error-messages="formErrors.billing_state"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-autocomplete>
                                    <v-text-field
                                        label="Zip"
                                        v-model="selectedCustomer.billing_zip"
                                        :error-messages="formErrors.billing_zip"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-text-field>
                                </div>
                                <div>
                                    <h3 class="font-bold">Shipping Address</h3>
                                    <v-text-field
                                        label="Address 1"
                                        v-model="selectedCustomer.shipping_address_1"
                                        :error-messages="formErrors.shipping_address_1"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-text-field>
                                    <v-text-field
                                        label="Address 2"
                                        v-model="selectedCustomer.shipping_address_2"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-text-field>
                                    <v-text-field
                                        label="City"
                                        v-model="selectedCustomer.shipping_city"
                                        :error-messages="formErrors.shipping_city"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-text-field>
                                    <v-autocomplete
                                        label="State"
                                        v-model="selectedCustomer.shipping_state"
                                        :items="stateAbbreviations"
                                        :error-messages="formErrors.shipping_state"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-autocomplete>
                                    <v-text-field
                                        label="Zip"
                                        v-model="selectedCustomer.shipping_zip"
                                        :error-messages="formErrors.shipping_zip"
                                        :disabled="loading[selectedCustomer.id]"
                                        density="compact"
                                    ></v-text-field>
                                </div>
                            </v-form>
                        </v-card-text>
                        <v-card-actions>
                            <v-btn color="primary" text @click="dialog = false" :disabled="loading[selectedCustomer.id]">Cancel</v-btn>
                            <v-btn color="primary" @click="updateCustomer" :loading="loading[selectedCustomer.id]" text>
                                <template v-if="loading[selectedCustomer.id]">
                                    <v-progress-circular indeterminate size="20" color="white"></v-progress-circular>
                                </template>
                                <template v-else>
                                    Save
                                </template>
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>

                <v-snackbar v-model="snackbar" :color="snackbarColor" top>
                    {{ snackbarMessage }}
                </v-snackbar>
            </v-container>
        </v-main>
    </v-app>
</template>

<style scoped>
.v-data-table-footer {
    background: rgb(var(--v-theme-surface-light)) !important;
    color: rgba(var(--v-theme-on-surface-light),var(--v-high-emphasis-opacity)) !important;
}

.add-customer-header {
    background: rgb(var(--v-theme-surface-light));
    color: rgba(var(--v-theme-on-surface-light),var(--v-high-emphasis-opacity));
    width: calc(100% + 32px);
    height: 64px;
    margin: -16px -16px 16px -16px;
    align-content: center;
}
</style>