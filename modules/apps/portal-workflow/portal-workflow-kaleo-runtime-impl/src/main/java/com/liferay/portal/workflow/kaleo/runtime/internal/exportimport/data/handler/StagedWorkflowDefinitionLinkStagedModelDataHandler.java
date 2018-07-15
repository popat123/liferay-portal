/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.portal.workflow.kaleo.runtime.internal.exportimport.data.handler;

import com.liferay.exportimport.kernel.lar.BaseStagedModelDataHandler;
import com.liferay.exportimport.kernel.lar.PortletDataContext;
import com.liferay.exportimport.kernel.lar.PortletDataException;
import com.liferay.exportimport.kernel.lar.StagedModelDataHandler;
import com.liferay.exportimport.kernel.lar.StagedModelDataHandlerUtil;
import com.liferay.exportimport.staged.model.repository.StagedModelRepository;
import com.liferay.exportimport.staged.model.repository.StagedModelRepositoryRegistryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.model.StagedModel;
import com.liferay.portal.kernel.service.WorkflowDefinitionLinkLocalService;
import com.liferay.portal.kernel.workflow.adapter.StagedWorkflowDefinitionLink;
import com.liferay.portal.kernel.xml.Element;

import java.util.Collections;
import java.util.List;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Zoltan Csaszi
 */
@Component(immediate = true, service = StagedModelDataHandler.class)
public class StagedWorkflowDefinitionLinkStagedModelDataHandler
	extends BaseStagedModelDataHandler<StagedWorkflowDefinitionLink> {

	public static final String[] CLASS_NAMES =
		{StagedWorkflowDefinitionLink.class.getName()};

	@Override
	public void deleteStagedModel(StagedWorkflowDefinitionLink stagedModel)
		throws PortalException {

		_workflowDefinitionLinkLocalService.deleteWorkflowDefinitionLink(
			stagedModel);
	}

	@Override
	public void deleteStagedModel(
			String uuid, long groupId, String className, String extraData)
		throws PortalException {
	}

	@Override
	public List<StagedWorkflowDefinitionLink>
		fetchStagedModelsByUuidAndCompanyId(String uuid, long companyId) {

		return Collections.emptyList();
	}

	@Override
	public String[] getClassNames() {
		return CLASS_NAMES;
	}

	@Override
	protected void doExportStagedModel(
			PortletDataContext portletDataContext,
			StagedWorkflowDefinitionLink stagedWorkflowDefinitionLink)
		throws Exception {

		Element element = portletDataContext.getExportDataElement(
			stagedWorkflowDefinitionLink);

		element.addAttribute(
			"display-name",
			stagedWorkflowDefinitionLink.getWorkflowDefinitionName());
		element.addAttribute(
			"version",
			String.valueOf(
				stagedWorkflowDefinitionLink.getWorkflowDefinitionVersion()));

		StagedModelRepository stagedModelRepository =
			StagedModelRepositoryRegistryUtil.getStagedModelRepository(
				stagedWorkflowDefinitionLink.getClassName());

		StagedModel stagedModel = stagedModelRepository.getStagedModel(
			stagedWorkflowDefinitionLink.getClassPK());

		StagedModelDataHandlerUtil.exportReferenceStagedModel(
			portletDataContext, stagedWorkflowDefinitionLink, stagedModel,
			PortletDataContext.REFERENCE_TYPE_DEPENDENCY);
	}

	@Override
	protected void doImportMissingReference(
			PortletDataContext portletDataContext, Element referenceElement)
		throws PortletDataException {
	}

	@Override
	protected void doImportStagedModel(
			PortletDataContext portletDataContext,
			StagedWorkflowDefinitionLink stagedModel)
		throws Exception {
	}

	@Reference(unbind = "-")
	protected void setWorkflowDefinitionLinkLocalService(
		WorkflowDefinitionLinkLocalService workflowDefinitionLinkLocalService) {

		_workflowDefinitionLinkLocalService =
			workflowDefinitionLinkLocalService;
	}

	private WorkflowDefinitionLinkLocalService
		_workflowDefinitionLinkLocalService;

}