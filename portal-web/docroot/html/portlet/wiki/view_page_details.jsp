<%
/**
 * Copyright (c) 2000-2009 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ include file="/html/portlet/wiki/init.jsp" %>

<%
WikiNode node = (WikiNode)request.getAttribute(WebKeys.WIKI_NODE);
WikiPage wikiPage = (WikiPage)request.getAttribute(WebKeys.WIKI_PAGE);

String[] attachments = new String[0];

if (wikiPage != null) {
	attachments = wikiPage.getAttachmentsFiles();
}

int numOfVersions = WikiPageLocalServiceUtil.getPagesCount(wikiPage.getNodeId(), wikiPage.getTitle());
WikiPage initialPage = (WikiPage)WikiPageLocalServiceUtil.getPages(wikiPage.getNodeId(), wikiPage.getTitle(), numOfVersions - 1, numOfVersions).get(0);

PortletURL viewPageURL = renderResponse.createRenderURL();

viewPageURL.setParameter("struts_action", "/wiki/view");
viewPageURL.setParameter("nodeName", node.getName());
viewPageURL.setParameter("title", wikiPage.getTitle());

PortletURL editPageURL = renderResponse.createRenderURL();

editPageURL.setParameter("struts_action", "/wiki/edit_page");
editPageURL.setParameter("redirect", currentURL);
editPageURL.setParameter("nodeId", String.valueOf(node.getNodeId()));
editPageURL.setParameter("title", wikiPage.getTitle());

PortalUtil.addPortletBreadcrumbEntry(request, wikiPage.getTitle(), viewPageURL.toString());
PortalUtil.addPortletBreadcrumbEntry(request, LanguageUtil.get(pageContext, "details"), currentURL);
%>

<liferay-util:include page="/html/portlet/wiki/top_links.jsp" />

<liferay-util:include page="/html/portlet/wiki/page_tabs.jsp">
	<liferay-util:param name="tabs1" value="details" />
</liferay-util:include>

<%
int count = 0;
%>

<table class="lfr-table page-info">
<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
	<th>
		<liferay-ui:message key="title" />
	</th>
	<td>
		<%= wikiPage.getTitle() %>
	</td>
</tr>
<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
	<th>
		<liferay-ui:message key="format" />
	</th>
	<td>
		<liferay-ui:message key='<%= "wiki.formats." + wikiPage.getFormat() %>'/>
	</td>
</tr>
<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
	<th>
		<liferay-ui:message key="latest-version" />
	</th>
	<td>
		<%= wikiPage.getVersion() %>

		<c:if test="<%= wikiPage.isMinorEdit() %>">
			(<liferay-ui:message key="minor-edit" />)
		</c:if>
	</td>
</tr>
<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
	<th>
		<liferay-ui:message key="created-by" />
	</th>
	<td>
		<%= initialPage.getUserName() %> (<%= dateFormatDateTime.format(initialPage.getCreateDate()) %>)
	</td>
</tr>
<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
	<th>
		<liferay-ui:message key="last-changed-by" />
	</th>
	<td>
		<%= wikiPage.getUserName() %> (<%= dateFormatDateTime.format(wikiPage.getCreateDate()) %>)
	</td>
</tr>
<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
	<th>
		<liferay-ui:message key="attachments" />
	</th>
	<td>
		<%= attachments.length %>
	</td>
</tr>

<c:if test="<%= PrefsPropsUtil.getBoolean(PropsKeys.OPENOFFICE_SERVER_ENABLED, PropsValues.OPENOFFICE_SERVER_ENABLED) && WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.VIEW) %>">

	<%
	String[] conversions = DocumentConversionUtil.getConversions("html");

	PortletURL exportPageURL = renderResponse.createActionURL();

	exportPageURL.setWindowState(LiferayWindowState.EXCLUSIVE);

	exportPageURL.setParameter("struts_action", "/wiki/export_page");
	exportPageURL.setParameter("nodeId", String.valueOf(node.getNodeId()));
	exportPageURL.setParameter("nodeName", node.getName());
	exportPageURL.setParameter("title", wikiPage.getTitle());
	exportPageURL.setParameter("version", String.valueOf(wikiPage.getVersion()));
	%>

	<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
		<th>
			<liferay-ui:message key="convert-to" />
		</th>
		<td>
			<liferay-ui:icon-list>

			<%
			for (String conversion : conversions) {
				exportPageURL.setParameter("targetExtension", conversion);
			%>

				<liferay-ui:icon
					image='<%= "../document_library/" + conversion %>'
					message="<%= conversion.toUpperCase() %>"
					url="<%= exportPageURL.toString() %>"
					method="get"
					label="<%= true %>"
				/>

			<%
			}
			%>

			</liferay-ui:icon-list>
		</td>
	</tr>
</c:if>

<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
	<th>
		<liferay-ui:message key="rss-subscription" />
	</th>
	<td>
		<liferay-ui:icon-list>
			<liferay-ui:icon image="rss" message="Atom 1.0" url='<%= themeDisplay.getPathMain() + "/wiki/rss?p_l_id=" + plid + "&companyId=" + company.getCompanyId() + "&nodeId=" + wikiPage.getNodeId() + "&title=" + wikiPage.getTitle() + rssURLAtomParams %>' target="_blank" label="<%= true %>" />

			<liferay-ui:icon image="rss" message="RSS 1.0" url='<%= themeDisplay.getPathMain() + "/wiki/rss?p_l_id=" + plid + "&companyId=" + company.getCompanyId() + "&nodeId=" + wikiPage.getNodeId() + "&title=" + wikiPage.getTitle() + rssURLRSS10Params %>' target="_blank" label="<%= true %>" />

			<liferay-ui:icon image="rss" message="RSS 2.0" url='<%= themeDisplay.getPathMain() + "/wiki/rss?p_l_id=" + plid + "&companyId=" + company.getCompanyId() + "&nodeId=" + wikiPage.getNodeId() + "&title=" + wikiPage.getTitle() + rssURLRSS20Params %>' target="_blank" label="<%= true %>" />
		</liferay-ui:icon-list>
	</td>
</tr>

<c:if test="<%= WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.SUBSCRIBE) || WikiNodePermission.contains(permissionChecker, node, ActionKeys.SUBSCRIBE) %>">
	<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
		<th>
			<liferay-ui:message key="email-subscription" />
		</th>
		<td>
			<table class="lfr-table subscription-info">

			<c:if test="<%= WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.SUBSCRIBE) %>">
				<tr>
					<c:choose>
						<c:when test="<%= SubscriptionLocalServiceUtil.isSubscribed(user.getCompanyId(), user.getUserId(), WikiPage.class.getName(), wikiPage.getResourcePrimKey()) %>">
							<td>
								<liferay-ui:message key="you-are-subscribed-to-this-page" />
							</td>
							<td>
								<portlet:actionURL windowState="<%= WindowState.MAXIMIZED.toString() %>" var="unsubscribeURL">
									<portlet:param name="struts_action" value="/wiki/edit_page" />
									<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.UNSUBSCRIBE %>" />
									<portlet:param name="redirect" value="<%= currentURL %>" />
									<portlet:param name="nodeId" value="<%= String.valueOf(wikiPage.getNodeId()) %>" />
									<portlet:param name="title" value="<%= String.valueOf(wikiPage.getTitle()) %>" />
								</portlet:actionURL>

								<liferay-ui:icon image="unsubscribe" url="<%= unsubscribeURL %>" label="<%= true %>" />
							</td>
						</c:when>
						<c:otherwise>
							<td>
								<liferay-ui:message key="you-are-not-subscribed-to-this-page" />
							</td>
							<td>
								<portlet:actionURL windowState="<%= WindowState.MAXIMIZED.toString() %>" var="subscribeURL">
									<portlet:param name="struts_action" value="/wiki/edit_page" />
									<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.SUBSCRIBE %>" />
									<portlet:param name="redirect" value="<%= currentURL %>" />
									<portlet:param name="nodeId" value="<%= String.valueOf(wikiPage.getNodeId()) %>" />
									<portlet:param name="title" value="<%= String.valueOf(wikiPage.getTitle()) %>" />
								</portlet:actionURL>

								<liferay-ui:icon image="subscribe" url="<%= subscribeURL %>" label="<%= true %>" />
							</td>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:if>

			<c:if test="<%= WikiNodePermission.contains(permissionChecker, node, ActionKeys.SUBSCRIBE) %>">
				<tr>
					<c:choose>
						<c:when test="<%= SubscriptionLocalServiceUtil.isSubscribed(user.getCompanyId(), user.getUserId(), WikiNode.class.getName(), node.getNodeId()) %>">
							<td>
								<liferay-ui:message key="you-are-subscribed-to-this-wiki" />
							</td>
							<td>
								<portlet:actionURL windowState="<%= WindowState.MAXIMIZED.toString() %>" var="unsubscribeURL">
									<portlet:param name="struts_action" value="/wiki/edit_node" />
									<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.UNSUBSCRIBE %>" />
									<portlet:param name="redirect" value="<%= currentURL %>" />
									<portlet:param name="nodeId" value="<%= String.valueOf(node.getNodeId()) %>" />
								</portlet:actionURL>

								<liferay-ui:icon image="unsubscribe" url="<%= unsubscribeURL %>" label="<%= true %>" />
							</td>
						</c:when>
						<c:otherwise>
							<td>
								<liferay-ui:message key="you-are-not-subscribed-to-this-wiki" />
							</td>
							<td>
								<portlet:actionURL windowState="<%= WindowState.MAXIMIZED.toString() %>" var="subscribeURL">
									<portlet:param name="struts_action" value="/wiki/edit_node" />
									<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.SUBSCRIBE %>" />
									<portlet:param name="redirect" value="<%= currentURL %>" />
									<portlet:param name="nodeId" value="<%= String.valueOf(node.getNodeId()) %>" />
								</portlet:actionURL>

								<liferay-ui:icon image="subscribe" url="<%= subscribeURL %>" label="<%= true %>" />
							</td>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:if>

			</table>
		</td>
	</tr>
</c:if>

<c:if test="<%= WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.PERMISSIONS) || (WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.UPDATE) && WikiNodePermission.contains(permissionChecker, wikiPage.getNodeId(), ActionKeys.ADD_PAGE)) || WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.DELETE) %>">
	<tr class="portlet-section-body<%= MathUtil.isOdd(count++) ? "-alternate" : "" %> results-row <%= MathUtil.isOdd(count) ? "alt" : "" %>">
		<th>
			<liferay-ui:message key="advanced-actions" />
		</th>
		<td>
			<liferay-ui:icon-list>
				<c:if test="<%= WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.PERMISSIONS) %>">
					<liferay-security:permissionsURL
						modelResource="<%= WikiPage.class.getName() %>"
						modelResourceDescription="<%= wikiPage.getTitle() %>"
						resourcePrimKey="<%= String.valueOf(wikiPage.getResourcePrimKey()) %>"
						var="permissionsURL"
					/>

					<liferay-ui:icon image="permissions" url="<%= permissionsURL %>" label="<%= true %>" />
				</c:if>

				<c:if test="<%= WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.UPDATE) && WikiNodePermission.contains(permissionChecker, wikiPage.getNodeId(), ActionKeys.ADD_PAGE) %>">

					<%
					PortletURL copyPageURL = PortletURLUtil.clone(viewPageURL, renderResponse);

					copyPageURL.setParameter("struts_action", "/wiki/edit_page");
					copyPageURL.setParameter("redirect", viewPageURL.toString());
					copyPageURL.setParameter("nodeId", String.valueOf(wikiPage.getNodeId()));
					copyPageURL.setParameter("title", StringPool.BLANK);
					copyPageURL.setParameter("editTitle", "1");
					copyPageURL.setParameter("templateNodeId", String.valueOf(wikiPage.getNodeId()));
					copyPageURL.setParameter("templateTitle", wikiPage.getTitle());
					%>

					<liferay-ui:icon image="copy" url="<%= copyPageURL.toString() %>" label="<%= true %>" />
				</c:if>

				<c:if test="<%= WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.DELETE) && WikiNodePermission.contains(permissionChecker, wikiPage.getNodeId(), ActionKeys.ADD_PAGE) %>">

					<%
					PortletURL movePageURL = PortletURLUtil.clone(viewPageURL, renderResponse);

					movePageURL.setParameter("struts_action", "/wiki/move_page");
					movePageURL.setParameter("redirect", viewPageURL.toString());
					%>

					<liferay-ui:icon image="forward" message="move" url="<%= movePageURL.toString() %>" label="<%= true %>" />
				</c:if>

				<c:if test="<%= WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.DELETE) %>">

					<%
					PortletURL frontPageURL = PortletURLUtil.clone(viewPageURL, renderResponse);

					frontPageURL.setParameter("title", WikiPageImpl.FRONT_PAGE);

					PortletURL deletePageURL = PortletURLUtil.clone(editPageURL, PortletRequest.ACTION_PHASE, renderResponse);

					deletePageURL.setParameter(Constants.CMD, Constants.DELETE);
					deletePageURL.setParameter("redirect", frontPageURL.toString());
					%>

					<liferay-ui:icon-delete url="<%= deletePageURL.toString() %>" label="<%= true %>" />
				</c:if>
			</liferay-ui:icon-list>
		</td>
	</tr>
</c:if>

</table>