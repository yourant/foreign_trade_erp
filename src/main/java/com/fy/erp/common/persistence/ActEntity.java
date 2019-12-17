/**
 *
 */
package com.fy.erp.common.persistence;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fy.erp.modules.act.entity.Act;

/**
 * Activiti Entity类
 * @author ThinkGem
 * @version 2013-05-28
 */
public abstract class ActEntity<T> extends DataEntity<T> implements Serializable {

	private static final long serialVersionUID = 1L;

	protected Act act; 		// 流程任务对象

	private boolean draft = true; // 判断是否是保存草稿，还是流程流转下一节点

	public boolean isDraft() {
		return draft;
	}

	public void setDraft(boolean draft) {
		this.draft = draft;
	}

	public ActEntity() {
		super();
	}
	
	public ActEntity(String id) {
		super(id);
	}
	
	@JsonIgnore
	public Act getAct() {
		if (act == null){
			act = new Act();
		}
		return act;
	}

	public void setAct(Act act) {
		this.act = act;
	}

	/**
	 * 获取流程实例ID
	 * @return
	 */
	public String getProcInsId() {
		return this.getAct().getProcInsId();
	}

	/**
	 * 设置流程实例ID
	 * @param procInsId
	 */
	public void setProcInsId(String procInsId) {
		this.getAct().setProcInsId(procInsId);
	}
}
